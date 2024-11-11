output "cluster_endpoint" {
  description = "The endpoint of the EKS cluster."
  value       = aws_eks_cluster.cluster1.endpoint
}

output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.cluster1.name
}

output "cluster_certificate_authority" {
  description = "The certificate authority data for the EKS cluster."
  value       = aws_eks_cluster.cluster1.certificate_authority[0].data
}

output "cluster_id" {
  description = "The ID of the EKS cluster."
  value       = aws_eks_cluster.cluster1.*.id
}
