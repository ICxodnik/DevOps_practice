output "argocd_url" {
  description = "URL для доступу до Argo CD"
  value       = try("http://${data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].hostname}", "Pending LoadBalancer assignment")
}

data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = var.argo_namespace
  }
  depends_on = [helm_release.argocd]
}

output "argocd_admin_password" {
  description = "Пароль адміністратора Argo CD"
  value       = var.argo_admin_password
  sensitive   = true
}

output "argocd_namespace" {
  description = "Namespace де встановлено Argo CD"
  value       = var.argo_namespace
}

output "app_namespace" {
  description = "Namespace де розгорнуто додаток"
  value       = var.app_namespace
}

output "app_name" {
  description = "Назва Argo CD Application"
  value       = var.app_name
} 