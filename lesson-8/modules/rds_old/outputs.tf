# DB Subnet Group outputs
output "db_subnet_group_name" {
  description = "Назва DB Subnet Group"
  value       = aws_db_subnet_group.rds.name
}

output "db_subnet_group_arn" {
  description = "ARN DB Subnet Group"
  value       = aws_db_subnet_group.rds.arn
}

# Security Group outputs
output "security_group_id" {
  description = "ID Security Group для RDS"
  value       = aws_security_group.rds.id
}

output "security_group_name" {
  description = "Назва Security Group для RDS"
  value       = aws_security_group.rds.name
}

# Parameter Group outputs
output "parameter_group_name" {
  description = "Назва Parameter Group"
  value       = aws_db_parameter_group.rds.name
}

output "parameter_group_arn" {
  description = "ARN Parameter Group"
  value       = aws_db_parameter_group.rds.arn
}

# Aurora Cluster outputs (якщо use_aurora = true)
output "aurora_cluster_id" {
  description = "ID Aurora Cluster"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].id : null
}

output "aurora_cluster_endpoint" {
  description = "Writer endpoint Aurora Cluster"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : null
}

output "aurora_cluster_reader_endpoint" {
  description = "Reader endpoint Aurora Cluster"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].reader_endpoint : null
}

output "aurora_cluster_port" {
  description = "Порт Aurora Cluster"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].port : null
}

output "aurora_cluster_arn" {
  description = "ARN Aurora Cluster"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].arn : null
}

# Aurora Instance outputs
output "aurora_writer_endpoint" {
  description = "Endpoint Aurora Writer instance"
  value       = var.use_aurora ? aws_rds_cluster_instance.aurora_writer[0].endpoint : null
}

output "aurora_reader_endpoints" {
  description = "Endpoints Aurora Reader instances"
  value       = var.use_aurora ? aws_rds_cluster_instance.aurora_readers[*].endpoint : []
}

# RDS Instance outputs (якщо use_aurora = false)
output "rds_instance_id" {
  description = "ID RDS Instance"
  value       = var.use_aurora ? null : aws_db_instance.rds[0].id
}

output "rds_instance_endpoint" {
  description = "Endpoint RDS Instance"
  value       = var.use_aurora ? null : aws_db_instance.rds[0].endpoint
}

output "rds_instance_port" {
  description = "Порт RDS Instance"
  value       = var.use_aurora ? null : aws_db_instance.rds[0].port
}

output "rds_instance_arn" {
  description = "ARN RDS Instance"
  value       = var.use_aurora ? null : aws_db_instance.rds[0].arn
}

# Загальні outputs
output "database_name" {
  description = "Назва бази даних"
  value       = var.database_name
}

output "master_username" {
  description = "Ім'я користувача адміністратора"
  value       = var.master_username
}

output "engine" {
  description = "Тип двигуна бази даних"
  value       = var.engine
}

output "engine_version" {
  description = "Версія двигуна бази даних"
  value       = var.engine_version
}

# Connection string outputs
output "connection_string" {
  description = "Рядок підключення до бази даних"
  value = var.use_aurora ? (
    "postgresql://${var.master_username}:${var.master_password}@${aws_rds_cluster.aurora[0].endpoint}:${aws_rds_cluster.aurora[0].port}/${var.database_name}"
  ) : (
    "postgresql://${var.master_username}:${var.master_password}@${aws_db_instance.rds[0].endpoint}:${aws_db_instance.rds[0].port}/${var.database_name}"
  )
  sensitive = true
} 