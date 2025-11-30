# S3 Backend outputs
output "s3_bucket_name" {
  description = "Назва S3 бакета для Terraform state"
  value       = module.s3_backend.bucket_name
}

output "dynamodb_table_name" {
  description = "Назва DynamoDB таблиці для Terraform locks"
  value       = module.s3_backend.table_name
}

# VPC outputs
output "vpc_id" {
  description = "ID VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "ID публічних підмереж"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "ID приватних підмереж"
  value       = module.vpc.private_subnet_ids
}

# ECR outputs
output "ecr_repository_url" {
  description = "URL ECR репозиторію"
  value       = module.ecr.repository_url
}

output "ecr_repository_name" {
  description = "Назва ECR репозиторію"
  value       = module.ecr.repository_name
}

# EKS outputs
output "cluster_name" {
  description = "Назва EKS кластера"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint EKS кластера"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "CA certificate data для EKS кластера"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL для EKS кластера"
  value       = module.eks.cluster_oidc_issuer_url
}

# Jenkins outputs
output "jenkins_url" {
  description = "URL для доступу до Jenkins"
  value       = module.jenkins.jenkins_url
}

output "jenkins_admin_password" {
  description = "Пароль адміністратора Jenkins"
  value       = module.jenkins.jenkins_admin_password
  sensitive   = true
}

output "jenkins_namespace" {
  description = "Namespace де встановлено Jenkins"
  value       = module.jenkins.jenkins_namespace
}

# Argo CD outputs
output "argocd_url" {
  description = "URL для доступу до Argo CD"
  value       = module.argo_cd.argocd_url
}

output "argocd_admin_password" {
  description = "Пароль адміністратора Argo CD"
  value       = module.argo_cd.argocd_admin_password
  sensitive   = true
}

output "argocd_namespace" {
  description = "Namespace де встановлено Argo CD"
  value       = module.argo_cd.argocd_namespace
}

output "app_namespace" {
  description = "Namespace де розгорнуто додаток"
  value       = module.argo_cd.app_namespace
}

output "app_name" {
  description = "Назва Argo CD Application"
  value       = module.argo_cd.app_name
}

# RDS outputs
output "rds_instance_endpoint" {
  description = "Endpoint RDS Instance"
  value       = module.rds.rds_instance_endpoint
}

output "rds_instance_port" {
  description = "Порт RDS Instance"
  value       = module.rds.rds_instance_port
}

output "database_name" {
  description = "Назва бази даних"
  value       = module.rds.database_name
}

output "master_username" {
  description = "Ім'я користувача адміністратора"
  value       = module.rds.master_username
}

output "db_subnet_group_name" {
  description = "Назва DB Subnet Group"
  value       = module.rds.db_subnet_group_name
}

output "security_group_id" {
  description = "ID Security Group для RDS"
  value       = module.rds.security_group_id
}

output "parameter_group_name" {
  description = "Назва Parameter Group"
  value       = module.rds.parameter_group_name
} 