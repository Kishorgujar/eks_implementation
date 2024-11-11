variable "region" {
  description = "The AWS region where the VPC will be created."
  type        = string
}

variable "vpc_name" {
  description = "Specifies the name assigned to the VPC."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block assigned to the VPC."
  type        = string
}

variable "allowed_cidrs" {
  description = "List of CIDR blocks allowed to access the EKS cluster."
  type        = list(string)
}

variable "tags" {
  description = "Key-value pairs of tags to apply to all resources."
  type        = map(string)
}

variable "subnets" {
  description = "Map of subnet configurations, including CIDRs and names for each subnet."
  type = map(object({
    cidrs = list(string)
    names = list(string)
  }))
}

variable "aws_internet_gateway_name" {
  description = "Specifies the name of the internet gateway for the VPC."
  type        = string
}

variable "aws_pub_route1_table_name" {
  description = "Name of the public route table within the VPC."
  type        = string
}

variable "NAT_GW_EIP_Name" {
  description = "Specifies the name of the Elastic IP associated with the NAT Gateway."
  type        = string
}

variable "NAT_GW_Name" {
  description = "The name assigned to the NAT Gateway."
  type        = string
}

variable "aws_priv_route1_table_name" {
  description = "Name of the private route table within the VPC."
  type        = string
}

variable "security_group_name" {
  description = "The name assigned to the security group."
  type        = string
}

variable "eks_role_name" {
  description = "The name of the IAM role designated for EKS management."
  type        = string
}

variable "eks_role_tag" {
  description = "Tag assigned to the IAM role for EKS."
  type        = string
}

variable "node_role_name" {
  description = "The name of the IAM role assigned to the EKS node group."
  type        = string
}

variable "node_role_tag" {
  description = "Tag assigned to the IAM role for the EKS node group."
  type        = string
}

variable "cluster_role_name" {
  description = "Specifies the name of the IAM role assigned to the EKS cluster."
  type        = string
}

variable "node_group_name" {
  description = "The name assigned to the EKS node group."
  type        = string
}

variable "node_desired_size" {
  description = "Sets the desired number of worker nodes for the EKS node group."
  type        = number
}

variable "node_min_size" {
  description = "Specifies the minimum number of worker nodes for the EKS node group."
  type        = number
}

variable "node_max_size" {
  description = "Defines the maximum number of worker nodes for the EKS node group."
  type        = number
}

variable "ami_type" {
  description = "The AMI type for the node group"
  type        = string
}

variable "node_instance_type" {
  description = "Node Instance Type"
  type        = list(string)
}

variable "iam_role_node" {
  description = "Specifies the IAM role assigned to the EKS node group."
  type        = string
}

variable "cluster_tag" {
  description = "Tag assigned to the EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Specifies the desired Kubernetes version for the EKS cluster."
  type        = string
}

variable "eks_addons" {
  description = "List of optional EKS add-ons to install in the cluster."
  type        = list(string)
}

variable "eks_addon_versions" {
  description = "Map of EKS add-on names to their versions"
  type        = map(string)
}

variable "cluster_name" {
  description = "The name assigned to the EKS cluster."
  type        = string
}

variable "account_id" {
  description = "The AWS Account ID where resources are provisioned."
  type        = string
}

# Declare the variable for the KMS key ARN
variable "ebs_eks_kms_key_arn" {
  description = "ARN of the KMS key for EKS encryption. Leave empty to create a default key."
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for worker nodes."
  type        = string
}