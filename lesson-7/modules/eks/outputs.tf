output "cluster_id" {
  description = "ID EKS кластера"
  value       = aws_eks_cluster.main.id
}

output "cluster_name" {
  description = "Ім'я EKS кластера"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint EKS кластера"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "node_group_id" {
  description = "ID групи вузлів"
  value       = aws_eks_node_group.main.id
}

output "node_group_arn" {
  description = "ARN групи вузлів"
  value       = aws_eks_node_group.main.arn
}

output "node_group_status" {
  description = "Статус групи вузлів"
  value       = aws_eks_node_group.main.status
} 