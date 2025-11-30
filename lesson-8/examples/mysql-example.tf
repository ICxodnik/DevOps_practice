# Приклад використання MySQL RDS Instance
module "mysql_example" {
  source = "../modules/rds"

  # Основні налаштування
  use_aurora = false
  identifier = "mysql-example"
  
  # Двигун бази даних
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.micro"
  
  # База даних
  database_name   = "myapp"
  master_username = "admin"
  master_password = "your-secure-password"
  
  # Мережа
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  # Додаткові налаштування
  multi_az = true
  storage_encrypted = true
  backup_retention_period = 7
  
  # Параметри бази даних
  max_connections = 100
  work_mem        = 4
  
  tags = {
    Environment = "Development"
    Project     = "MySQLExample"
  }
} 