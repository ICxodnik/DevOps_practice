# Приклад використання PostgreSQL RDS Instance
module "postgres_example" {
  source = "../modules/rds"

  # Основні налаштування
  use_aurora = false
  identifier = "postgres-example"

  # Двигун бази даних
  engine         = "postgres"
  engine_version = "14.9"
  instance_class = "db.t3.micro"

  # База даних
  database_name   = "myapp"
  master_username = "admin"
  master_password = "your-secure-password"

  # Мережа
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  # Додаткові налаштування
  multi_az                = false # Для dev середовища
  storage_encrypted       = true
  backup_retention_period = 7

  # Параметри бази даних
  max_connections = 100
  log_statement   = "ddl" # Логуємо тільки DDL запити
  work_mem        = 4

  tags = {
    Environment = "Development"
    Project     = "PostgreSQLExample"
  }
} 