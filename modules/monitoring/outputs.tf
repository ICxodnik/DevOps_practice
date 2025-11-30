output "monitoring_namespace" {
  description = "Namespace де встановлено моніторинг"
  value       = var.monitoring_namespace
}

output "grafana_url" {
  description = "URL для доступу до Grafana"
  value       = try("http://${data.kubernetes_service.grafana.status[0].load_balancer[0].ingress[0].hostname}", "Pending LoadBalancer assignment")
}

data "kubernetes_service" "grafana" {
  metadata {
    name      = "prometheus-grafana"
    namespace = var.monitoring_namespace
  }
  depends_on = [helm_release.prometheus]
}

output "prometheus_url" {
  description = "URL для доступу до Prometheus"
  value       = "http://prometheus-operated.${var.monitoring_namespace}.svc.cluster.local:9090"
}

output "grafana_admin_password" {
  description = "Пароль адміністратора Grafana"
  value       = "admin123"
  sensitive   = true
}

