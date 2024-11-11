#eks
cluster_role_name  = "EKSRole"
node_group_name    = "MyNodeGroup"
node_desired_size  = "2"
node_max_size      = "3"
node_min_size      = "1"
node_instance_type = ["m5.xlarge"]
iam_role_node      = "EKSNodeRole"
cluster_tag        = "Cluster1"
cluster_name       = "my-eks-cluster"
kubernetes_version = "1.29"
eks_addons         = ["vpc-cni", "coredns", "kube-proxy"]
eks_addon_versions = {
  "vpc-cni"    = "v1.18.1-eksbuild.3"
  "coredns"    = "v1.11.1-eksbuild.9"
  "kube-proxy" = "v1.29.0-eksbuild.3"
}
#iam_role
eks_role_name  = "EKSRole"
eks_role_tag   = "EKS"
node_role_name = "EKSNodeRole"
node_role_tag  = "NodeGroup"

#vpc
region                     = "ap-south-1"
vpc_name                   = "my-vpc"
vpc_cidr                   = "192.168.0.0/16"
aws_internet_gateway_name  = "Public_IGW"
aws_pub_route1_table_name  = "Public_pub_route1"
NAT_GW_EIP_Name            = "NAT_GW_EIP"
NAT_GW_Name                = "EKS_NAT"
aws_priv_route1_table_name = "Private_pub_route1"
security_group_name        = "eks-security-group"
tags = {
  Environment = "Dev"
  Project     = "MyProject"
}

subnets = {
  public = {
    cidrs = ["192.168.0.0/20", "192.168.16.0/20"]
    names = ["Public_Subnet1", "Public_Subnet2"]
  }
  private = {
    cidrs = ["192.168.32.0/20", "192.168.64.0/20", "192.168.96.0/20", "192.168.112.0/20"]
    names = ["Private_Subnet1", "Private_Subnet2", "Private_Subnet3", "Private_Subnet4"]
  }
}
allowed_cidrs = ["0.0.0.0/0"]
