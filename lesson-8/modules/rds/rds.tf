# Звичайна RDS Instance (якщо use_aurora = false)
resource "aws_db_instance" "rds" {
  count = var.use_aurora ? 0 : 1

  identifier     = var.identifier
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  db_name  = var.database_name
  username = var.master_username
  password = var.master_password

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.rds.name

  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  storage_encrypted       = var.storage_encrypted
  deletion_protection     = var.deletion_protection

  skip_final_snapshot = true

  tags = merge(var.tags, {
    Name = "${var.identifier}-instance"
  })
} 