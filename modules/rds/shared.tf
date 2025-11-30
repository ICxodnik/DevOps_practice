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

  # Дозволяємо підключення з VPC для PostgreSQL
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