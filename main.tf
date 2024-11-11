module "vpc" {
  source                     = "./modules/vpc"
  region                     = var.region
  vpc_name                   = var.vpc_name
  vpc_cidr                   = var.vpc_cidr
  allowed_cidrs              = var.allowed_cidrs
  tags                       = var.tags
  subnets                    = var.subnets
  NAT_GW_EIP_Name            = var.NAT_GW_EIP_Name
  NAT_GW_Name                = var.NAT_GW_Name
  aws_internet_gateway_name  = var.aws_internet_gateway_name
  aws_pub_route1_table_name  = var.aws_pub_route1_table_name
  aws_priv_route1_table_name = var.aws_priv_route1_table_name
  security_group_name        = var.security_group_name
}



module "iam_role" {
  source         = "./modules/iam_role"
  account_id     = var.account_id
  environment    = terraform.workspace
  eks_role_name  = var.eks_role_name
  eks_role_tag   = var.eks_role_tag
  node_role_name = var.node_role_name
  node_role_tag  = var.node_role_tag
  tags           = var.tags
}

module "eks" {
  source                   = "./modules/eks"
  region                   = var.region
  cluster_name             = var.cluster_name
  cluster_role_arn         = module.iam_role.eks_role_arn
  node_role_arn            = module.iam_role.node_role_arn
  kubernetes_version       = var.kubernetes_version
  eks_addons               = var.eks_addons
  eks_addon_versions       = var.eks_addon_versions
  cluster_role_name        = var.cluster_role_name
  eks_role_arn             = module.iam_role.eks_role_arn
  node_group_name          = var.node_group_name
  node_desired_size        = var.node_desired_size
  node_max_size            = var.node_max_size
  node_min_size            = var.node_min_size
  ami_type                 = var.ami_type
  ami_id                   = var.ami_id
  node_instance_type       = var.node_instance_type
  iam_role_node            = var.iam_role_node
  load_balancer_policy_arn = module.iam_role.load_balancer_controller_policy_arn
  account_id               = var.account_id
  environment              = terraform.workspace
  tags                     = var.tags
  eks_kms_key_arn          = var.ebs_eks_kms_key_arn

  # Using the output maps for public and private subnet IDs
  subnet_ids = concat(
    [for name, id in module.vpc.public_subnet_ids : id],
    [for name, id in module.vpc.private_subnet_ids : id]
  )
  private_subnet = [
    module.vpc.private_subnet_ids["Private_Subnet1"],
    module.vpc.private_subnet_ids["Private_Subnet2"]
  ]
  security_group_ids      = [module.vpc.security_group_id]
  endpoint_public_access  = true
  endpoint_private_access = true
  cluster_tag             = var.cluster_tag
}
