# DB Subnet Group
resource "aws_db_subnet_group" "rds" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.identifier}-subnet-group"
  })
}

# Security Group для RDS
resource "aws_security_group" "rds" {
  name_prefix = "${var.identifier}-rds-sg"
  vpc_id      = var.vpc_id

  # Дозволяємо підключення з VPC
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_blocks
    description = "PostgreSQL access from VPC"
  }

  # Дозволяємо підключення з VPC для MySQL
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_blocks
    description = "MySQL access from VPC"
  }

  # Вихідний трафік
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(var.tags, {
    Name = "${var.identifier}-rds-sg"
  })
}

# Parameter Group
resource "aws_db_parameter_group" "rds" {
  family = var.use_aurora ? (
    var.engine == "aurora-postgresql" ? "aurora-postgresql14" : "aurora-mysql8.0"
    ) : (
    var.engine == "postgres" ? "postgres14" : "mysql8.0"
  )
  name = "${var.identifier}-parameter-group"

  parameter {
    name  = "max_connections"
    value = var.max_connections
  }

  parameter {
    name  = "log_statement"
    value = var.log_statement
  }

  parameter {
    name  = "work_mem"
    value = "${var.work_mem}MB"
  }

  tags = merge(var.tags, {
    Name = "${var.identifier}-parameter-group"
  })
}

# Aurora Cluster (якщо use_aurora = true)
resource "aws_rds_cluster" "aurora" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier              = var.identifier
  engine                          = var.engine
  engine_version                  = var.engine_version
  database_name                   = var.database_name
  master_username                 = var.master_username
  master_password                 = var.master_password
  db_subnet_group_name            = aws_db_subnet_group.rds.name
  vpc_security_group_ids          = [aws_security_group.rds.id]
  db_cluster_parameter_group_name = aws_db_parameter_group.rds.name

  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.backup_window
  preferred_maintenance_window = var.maintenance_window
  storage_encrypted            = var.storage_encrypted
  deletion_protection          = var.deletion_protection

  skip_final_snapshot = true

  tags = merge(var.tags, {
    Name = "${var.identifier}-cluster"
  })
}

# Aurora Cluster Instance (Writer)
resource "aws_rds_cluster_instance" "aurora_writer" {
  count = var.use_aurora ? 1 : 0

  identifier         = "${var.identifier}-writer"
  cluster_identifier = aws_rds_cluster.aurora[0].id
  instance_class     = var.instance_class
  engine             = var.engine
  engine_version     = var.engine_version

  db_parameter_group_name = aws_db_parameter_group.rds.name

  tags = merge(var.tags, {
    Name = "${var.identifier}-writer"
  })
}

# Aurora Cluster Instances (Readers)
resource "aws_rds_cluster_instance" "aurora_readers" {
  count = var.use_aurora ? max(0, var.aurora_cluster_size - 1) : 0

  identifier         = "${var.identifier}-reader-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora[0].id
  instance_class     = var.aurora_instance_class
  engine             = var.engine
  engine_version     = var.engine_version

  db_parameter_group_name = aws_db_parameter_group.rds.name

  tags = merge(var.tags, {
    Name = "${var.identifier}-reader-${count.index + 1}"
  })
}

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