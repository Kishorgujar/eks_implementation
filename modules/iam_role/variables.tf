variable "eks_role_name" {
  description = "Specifies the name of the IAM role designated for EKS management."
  type        = string
  default     = "EKSRole"
}

variable "eks_role_tag" {
  description = "Defines the primary tag assigned to the EKS IAM role."
  type        = string
  default     = "EKS"
}

variable "node_role_name" {
  description = "Specifies the name of the IAM role assigned to the EKS node group."
  type        = string
  default     = "EKSNodeRole"
}

variable "node_role_tag" {
  description = "Defines the primary tag assigned to the IAM role for the EKS node group."
  type        = string
  default     = "NodeGroup"
}

variable "load_balancer_controller_policy_name" {
  description = "Defines the name of the IAM policy used by the AWS Load Balancer Controller."
  type        = string
  default     = "AWSLoadBalancerControllerIAMPolicy"
}

variable "account_id" {
  description = "Specifies the AWS Account ID where resources are managed."
  type        = string
}

variable "environment" {
  description = "Indicates the environment for resource deployment (e.g., dev, prod)."
  type        = string
}

variable "tags" {
  description = "Key-value pairs of tags to apply across all managed resources."
  type        = map(string)
}

variable "cluster_name" {
  description = "The designated name for the EKS cluster."
  type        = string
  default     = "my-eks-cluster"
}

