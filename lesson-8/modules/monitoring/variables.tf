# EKS cluster змінні
variable "cluster_name" {
  description = "Назва EKS кластера"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint EKS кластера"
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "CA certificate data для EKS кластера"
  type        = string
}

# Monitoring змінні
variable "monitoring_namespace" {
  description = "Namespace для моніторингу"
  type        = string
  default     = "monitoring"
}

variable "prometheus_chart_version" {
  description = "Версія Prometheus Helm chart"
  type        = string
  default     = "55.0.0"
}

# Prometheus ресурси
variable "prometheus_cpu_request" {
  description = "CPU request для Prometheus"
  type        = string
  default     = "500m"
}

variable "prometheus_memory_request" {
  description = "Memory request для Prometheus"
  type        = string
  default     = "2Gi"
}

variable "prometheus_cpu_limit" {
  description = "CPU limit для Prometheus"
  type        = string
  default     = "2000m"
}

variable "prometheus_memory_limit" {
  description = "Memory limit для Prometheus"
  type        = string
  default     = "4Gi"
}

# Grafana ресурси
variable "grafana_cpu_request" {
  description = "CPU request для Grafana"
  type        = string
  default     = "200m"
}

variable "grafana_memory_request" {
  description = "Memory request для Grafana"
  type        = string
  default     = "512Mi"
}

variable "grafana_cpu_limit" {
  description = "CPU limit для Grafana"
  type        = string
  default     = "1000m"
}

variable "grafana_memory_limit" {
  description = "Memory limit для Grafana"
  type        = string
  default     = "1Gi"
}

