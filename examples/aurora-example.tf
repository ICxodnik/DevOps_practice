# Приклад використання Aurora Cluster
module "aurora_example" {
  source = "../modules/rds"

  # Основні налаштування
  use_aurora = true
  identifier = "aurora-example"

  # Двигун бази даних
  engine         = "aurora-postgresql"
  engine_version = "14.9"
  instance_class = "db.r6g.large"

  # База даних
  database_name   = "myapp"
  master_username = "admin"
  master_password = "your-secure-password"

  # Aurora налаштування
  aurora_cluster_size   = 3 # 1 writer + 2 readers
  aurora_instance_class = "db.r6g.large"

  # Мережа
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  # Додаткові налаштування
  storage_encrypted       = true
  backup_retention_period = 30

  # Параметри бази даних
  max_connections = 200
  log_statement   = "mod"
  work_mem        = 8

  tags = {
    Environment = "Production"
    Project     = "AuroraExample"
  }
} 