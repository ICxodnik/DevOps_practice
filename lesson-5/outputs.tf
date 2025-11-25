# Виведення інформації про S3 та DynamoDB
output "s3_bucket_name" {
  description = "Ім'я S3 бакета для стейт-файлів"
  value       = module.s3_backend.bucket_name
}

output "dynamodb_table_name" {
  description = "Ім'я DynamoDB таблиці для блокування"
  value       = module.s3_backend.table_name
}

# Виведення інформації про VPC
output "vpc_id" {
  description = "ID VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR блок VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "ID публічних підмереж"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "ID приватних підмереж"
  value       = module.vpc.private_subnet_ids
}

# Виведення інформації про ECR
output "ecr_repository_url" {
  description = "URL ECR репозиторію"
  value       = module.ecr.repository_url
}

output "ecr_repository_name" {
  description = "Ім'я ECR репозиторію"
  value       = module.ecr.repository_name
} 