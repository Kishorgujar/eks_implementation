output "eks_role_arn" {
  value       = aws_iam_role.eks_role.arn
  description = "The ARN of the IAM role for the EKS cluster"
}

output "node_role_arn" {
  value = aws_iam_role.node_role.arn
}

output "load_balancer_controller_policy_arn" {
  value       = aws_iam_policy.AWS_LoadBalancer_Controller_Policy.arn
  description = "The ARN of the Load Balancer Controller IAM Policy"
}

output "eks_kms_key_arn" {
  value = aws_kms_key.eks_kms_key.arn
}

output "eks_kms_key_id" {
  value = aws_kms_key.eks_kms_key.id
}

output "eks_service_role_arn" {
  value = aws_iam_role.eks_service_role.arn
}
