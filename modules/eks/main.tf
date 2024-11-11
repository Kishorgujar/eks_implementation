
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

locals {
  account_id  = var.account_id
  environment = terraform.workspace
}

resource "aws_cloudwatch_log_group" "EKS_CLUSTER_LOGS" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7

  lifecycle {
    #   prevent_destroy = true
  }
}

resource "aws_eks_cluster" "cluster1" {
  name                      = var.cluster_name
  role_arn                  = var.eks_role_arn # Use the variable here
  version                   = var.kubernetes_version
  enabled_cluster_log_types = var.cluster_log_types
  lifecycle {
    #   prevent_destroy = true
  }
  tags = merge(var.tags, {
    Name = var.cluster_tag
  })

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = var.security_group_ids
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
  }

  # Enable encryption for Secrets using the provided KMS key
  encryption_config {
    provider {
      key_arn = local.kms_key_to_use
    }
    resources = ["secrets"] 
  }
  depends_on = [
    aws_cloudwatch_log_group.EKS_CLUSTER_LOGS
  ]
}

resource "aws_launch_template" "eks_worker_launch_template" {
  name_prefix   = "eks-worker-"
  image_id      = var.ami_id 
  instance_type = var.node_instance_type[0]  

  block_device_mappings {
    device_name = var.device_name
    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
      encrypted   = var.encrypted
      kms_key_id  = local.kms_key_to_use  
    }
  }
    # Override tags for EC2 instances launched by the node group
  tag_specifications {
    resource_type = var.resource_type

    tags = merge(var.tags, {
      "EC2Instance" = "WorkerNode"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_node_group" "ec2_worker_nodes" {
  cluster_name    = aws_eks_cluster.cluster1.name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn 
  subnet_ids      = var.private_subnet
  version         = var.kubernetes_version
  instance_types  = var.node_instance_type
  ami_type        = var.ami_type
  lifecycle {
    #   prevent_destroy = true
  }

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

   # Apply tags to node group itself
  tags = merge(var.tags, {
    "NodeGroup" = var.node_group_name
  })

  # Block device mappings for EBS volume encryption
  launch_template {
    id = aws_launch_template.eks_worker_launch_template.id
    version = "$Latest"
  }

  depends_on = [
    aws_eks_cluster.cluster1
  ]
}

resource "aws_eks_addon" "addons" {
  # for_each                    = toset(var.eks_addons)
  for_each     = { for k, v in var.eks_addons : k => v if v != null }
  cluster_name = aws_eks_cluster.cluster1.name
  addon_name   = each.value
  # service_account_role_arn    = lookup(var.eks_addon_role_arns, each.key, null)
  service_account_role_arn    = lookup({ "vpc-cni" = "${aws_iam_role.EKS_VPC_CNI_Role.arn}" }, each.value, null)
  addon_version               = lookup(var.eks_addon_versions, each.value, null)
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_cluster.cluster1, aws_iam_role.EKS_VPC_CNI_Role
  ]
}


data "tls_certificate" "Cluster_TLS" {
  url = aws_eks_cluster.cluster1.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "EKS_IAM_Provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.Cluster_TLS.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.cluster1.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "EKS_Cluster_CNI_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.EKS_IAM_Provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.EKS_IAM_Provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "EKS_VPC_CNI_Role" {
  assume_role_policy = data.aws_iam_policy_document.EKS_Cluster_CNI_assume_role_policy.json
  name               = "${local.environment}-vpc-cni-role-${random_string.suffix.result}"
  lifecycle {
    #   prevent_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "EKS_VPC_CNI_Role_Attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.EKS_VPC_CNI_Role.name
  lifecycle {
    #   prevent_destroy = true
  }
}

# Define the kms_key_to_use locally
locals {
  kms_key_to_use = (
    var.ebs_eks_kms_key_arn != "" ? var.ebs_eks_kms_key_arn : aws_kms_key.default[0].arn
  )
}

resource "aws_kms_key" "default" {
  count = var.ebs_eks_kms_key_arn == "" ? 1 : 0

  description         = "Default KMS Key for EBS Encryption"
  enable_key_rotation = true
  tags = merge(var.tags, {
    Name = "Default-EKS-KMS-Key"
  })
}






