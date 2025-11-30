# Створюємо namespace для моніторингу
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.monitoring_namespace
  }
}

# Встановлюємо Prometheus через Helm
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.prometheus_chart_version
  namespace  = var.monitoring_namespace

  values = [
    file("${path.module}/prometheus-values.yaml")
  ]

  set {
    name  = "prometheus.prometheusSpec.resources.requests.cpu"
    value = var.prometheus_cpu_request
  }

  set {
    name  = "prometheus.prometheusSpec.resources.requests.memory"
    value = var.prometheus_memory_request
  }

  set {
    name  = "prometheus.prometheusSpec.resources.limits.cpu"
    value = var.prometheus_cpu_limit
  }

  set {
    name  = "prometheus.prometheusSpec.resources.limits.memory"
    value = var.prometheus_memory_limit
  }

  set {
    name  = "grafana.resources.requests.cpu"
    value = var.grafana_cpu_request
  }

  set {
    name  = "grafana.resources.requests.memory"
    value = var.grafana_memory_request
  }

  set {
    name  = "grafana.resources.limits.cpu"
    value = var.grafana_cpu_limit
  }

  set {
    name  = "grafana.resources.limits.memory"
    value = var.grafana_memory_limit
  }

  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }

  depends_on = [kubernetes_namespace.monitoring]
}

