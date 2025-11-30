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
