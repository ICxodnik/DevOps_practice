output "jenkins_url" {
  description = "URL для доступу до Jenkins"
  value       = try("http://${data.kubernetes_service.jenkins.status[0].load_balancer[0].ingress[0].hostname}", "Pending LoadBalancer assignment")
}

data "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = var.jenkins_namespace
  }
  depends_on = [helm_release.jenkins]
}

output "jenkins_admin_password" {
  description = "Пароль адміністратора Jenkins"
  value       = var.jenkins_admin_password
  sensitive   = true
}

output "jenkins_namespace" {
  description = "Namespace де встановлено Jenkins"
  value       = var.jenkins_namespace
}

output "jenkins_service_account_name" {
  description = "Назва ServiceAccount для Jenkins"
  value       = kubernetes_service_account.jenkins.metadata[0].name
}

output "jenkins_iam_role_arn" {
  description = "ARN IAM ролі для Jenkins"
  value       = aws_iam_role.jenkins_role.arn
} 