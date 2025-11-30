# EKS кластер змінні
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

# Argo CD змінні
variable "argo_namespace" {
  description = "Namespace для Argo CD"
  type        = string
  default     = "argocd"
}

variable "argo_admin_password" {
  description = "Пароль адміністратора Argo CD"
  type        = string
  default     = "admin123"
}

variable "argo_chart_version" {
  description = "Версія Argo CD Helm chart"
  type        = string
  default     = "5.46.7"
}

variable "argo_repository" {
  description = "Helm repository для Argo CD"
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

# Application змінні
variable "app_name" {
  description = "Назва Argo CD Application"
  type        = string
  default     = "django-app"
}

variable "app_namespace" {
  description = "Namespace для додатку"
  type        = string
  default     = "django-app"
}

variable "git_repo_url" {
  description = "URL Git репозиторію з Helm chart"
  type        = string
}

variable "git_repo_path" {
  description = "Шлях до Helm chart в репозиторії"
  type        = string
  default     = "charts/django-app"
}

variable "git_repo_target_revision" {
  description = "Гілка або тег для синхронізації"
  type        = string
  default     = "main"
}

# ECR змінні
variable "ecr_repository_url" {
  description = "URL ECR репозиторію"
  type        = string
}

# Argo CD ресурси
variable "argo_cpu_request" {
  description = "CPU request для Argo CD"
  type        = string
  default     = "500m"
}

variable "argo_memory_request" {
  description = "Memory request для Argo CD"
  type        = string
  default     = "1Gi"
}

variable "argo_cpu_limit" {
  description = "CPU limit для Argo CD"
  type        = string
  default     = "1000m"
}

variable "argo_memory_limit" {
  description = "Memory limit для Argo CD"
  type        = string
  default     = "2Gi"
} 