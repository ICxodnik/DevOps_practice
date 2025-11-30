# Приклад використання Aurora MySQL Cluster
module "aurora_mysql_example" {
  source = "../modules/rds"

  # Основні налаштування
  use_aurora = true
  identifier = "aurora-mysql-example"

  # Двигун бази даних
  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.05.1"
  instance_class = "db.r6g.large"

  # База даних
  database_name   = "myapp"
  master_username = "admin"
  master_password = "your-secure-password"

  # Aurora налаштування
  aurora_cluster_size   = 2 # 1 writer + 1 reader
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
    Project     = "AuroraMySQLExample"
  }
} 