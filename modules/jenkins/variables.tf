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

# Jenkins змінні
variable "jenkins_namespace" {
  description = "Namespace для Jenkins"
  type        = string
  default     = "jenkins"
}

variable "jenkins_admin_password" {
  description = "Пароль адміністратора Jenkins"
  type        = string
  default     = "admin123"
}

variable "jenkins_chart_version" {
  description = "Версія Jenkins Helm chart"
  type        = string
  default     = "4.6.0"
}

variable "jenkins_repository" {
  description = "Helm repository для Jenkins"
  type        = string
  default     = "https://charts.jenkins.io"
}

# ECR змінні
variable "ecr_repository_url" {
  description = "URL ECR репозиторію"
  type        = string
}

variable "aws_region" {
  description = "AWS регіон"
  type        = string
  default     = "us-west-2"
}

# Git змінні
variable "git_repo_url" {
  description = "URL Git репозиторію"
  type        = string
}

variable "git_credentials_id" {
  description = "ID Git credentials в Jenkins"
  type        = string
  default     = "github-credentials"
}

# Jenkins ресурси
variable "jenkins_cpu_request" {
  description = "CPU request для Jenkins"
  type        = string
  default     = "500m"
}

variable "jenkins_memory_request" {
  description = "Memory request для Jenkins"
  type        = string
  default     = "1Gi"
}

variable "jenkins_cpu_limit" {
  description = "CPU limit для Jenkins"
  type        = string
  default     = "1000m"
}

variable "jenkins_memory_limit" {
  description = "Memory limit для Jenkins"
  type        = string
  default     = "2Gi"
} 