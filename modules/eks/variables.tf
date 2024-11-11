variable "endpoint_private_access" {
  description = "Enables private access to the EKS cluster API server."
  type        = bool
  default     = true
}

variable "cluster_log_types" {
  description = "Specifies the types of logs to enable for the EKS cluster. Available options include: api, audit, authenticator, controllerManager, scheduler."
  type        = list(string)
  default     = ["api", "audit"]
}

variable "cluster_tag" {
  description = "Specifies the primary tag for the EKS cluster."
  type        = string
  default     = "Cluster1"
}

variable "eks_role_name" {
  description = "Defines the name of the IAM role for EKS."
  type        = string
  default     = "EKSRole"
}

variable "cluster_role_name" {
  description = "Defines the name of the IAM role associated with the EKS cluster."
  type        = string
}

variable "node_group_name" {
  description = "The name assigned to the EKS node group."
  type        = string
  default     = "MyNodeGroup"
}

variable "node_instance_type" {
  description = "Node Instance Type"
  type        = list(string)
}

variable "ami_type" {
  description = "The AMI type for the node group"
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

variable "node_role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role associated with the EKS node group."
  type        = string
}

variable "iam_role_node" {
  description = "The ARN of the IAM role designated for the EKS node group."
  type        = string
}

variable "region" {
  description = "Specifies the AWS region for deploying resources."
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "The designated name for the EKS cluster."
  type        = string
  default     = "my-eks-cluster"
}

variable "kubernetes_version" {
  description = "The desired Kubernetes version for the EKS cluster deployment."
  type        = string
}

variable "cluster_role_arn" {
  description = "The ARN of the IAM role linked to the EKS cluster."
  type        = string
  default     = "arn:aws:iam::975050350815:role/EKSRole"
}

variable "endpoint_public_access" {
  description = "Controls public access to the EKS cluster API server."
  type        = bool
  default     = true
}

variable "load_balancer_policy_arn" {
  description = "The ARN of the IAM policy for the Load Balancer Controller."
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

variable "account_id" {
  description = "The AWS Account ID where resources are provisioned."
  type        = string
}

variable "environment" {
  description = "Defines the environment for the deployment (e.g., dev, prod)."
  type        = string
}

variable "eks_role_arn" {
  description = "The ARN of the IAM role for the EKS cluster."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs associated with the EKS cluster."
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs associated with the EKS cluster."
  type        = list(string)
}

variable "private_subnet" {
  description = "A list of private subnet IDs designated for the EKS node group."
  type        = list(string)
}

variable "tags" {
  description = "Key-value pairs of tags to apply to created resources."
  type        = map(string)
}

# Declare the variable for the KMS key ARN
variable "eks_kms_key_arn" {
  description = "ARN of the KMS key for EKS encryption"
  type        = string
}

variable "ebs_eks_kms_key_arn" {
  description = "ARN of the KMS key for EKS encryption. Leave empty to create a default key."
  type        = string
  default     = ""
}

variable "ami_id" {
  description = "The AMI ID to use for worker nodes."
  type        = string
}

variable "device_name" {
  description = "Write EBS Device Name"
  type        = string
  default     = "/dev/xvda"
}

variable "volume_size" {
  description = "Give EBS Volume Device Name"
  type        = number
  default     = 50
}

variable "volume_type" {
  description = "Write EBS Device Type"
  type        = string
  default     = "gp3"
}

variable "encrypted" {
  description = "Controls public access to the EKS cluster API server."
  type        = bool
  default     = true
}

variable "resource_type" {
  description = "Write EBS Device Type"
  type        = string
  default     = "instance"
}