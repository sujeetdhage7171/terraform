output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "The API server endpoint for the EKS cluster."
  value       = aws_eks_cluster.this.endpoint
}

output "kubeconfig_data" {
  description = "Kubeconfig block (used to configure local access)."
  value = {
    cluster_arn = aws_eks_cluster.this.arn
    endpoint    = aws_eks_cluster.this.endpoint
    certificate = aws_eks_cluster.this.certificate_authority[0].data
  }
  sensitive = true
}