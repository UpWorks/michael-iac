terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Create the secret in AWS Secrets Manager for master credentials
resource "aws_secretsmanager_secret" "aurora_credentials" {
  name = "${local.name_prefix}-credentials"
}

resource "aws_secretsmanager_secret_version" "aurora_credentials" {
  secret_id = aws_secretsmanager_secret.aurora_credentials.id
  secret_string = jsonencode({
    username = var.master_username
    password = var.master_password
    engine   = "mysql"
    host     = aws_rds_cluster.aurora_cluster.endpoint
    port     = aws_rds_cluster.aurora_cluster.port
    dbname   = var.database_name
  })
}

# Aurora MySQL cluster
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier     = var.cluster_identifier
  engine                = "aurora-mysql"
  engine_version        = var.engine_version
  database_name         = var.database_name
  master_username       = var.master_username
  master_password       = var.master_password
  skip_final_snapshot   = true

  vpc_security_group_ids = [aws_security_group.aurora.id]
  db_subnet_group_name   = aws_db_subnet_group.aurora.name

  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  # Add IAM authentication
  iam_roles = [aws_iam_role.aurora_secret_access.arn]

  # Global database configuration
  global_cluster_identifier = var.global_cluster_enabled ? "${var.cluster_identifier}-global" : null
  storage_encrypted        = true
  deletion_protection     = false
}

# Aurora MySQL instance
resource "aws_rds_cluster_instance" "aurora_instances" {
  count               = var.instance_count
  identifier          = "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier  = aws_rds_cluster.aurora_cluster.id
  instance_class      = var.instance_class
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version
}

# Security group
resource "aws_security_group" "aurora" {
  name        = "${local.name_prefix}-aurora-sg"
  description = "Security group for Aurora MySQL cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.default_tags
}

# DB subnet group
resource "aws_db_subnet_group" "aurora" {
  name       = "${local.name_prefix}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = local.default_tags
}

# IAM role for Aurora to access Secrets Manager
resource "aws_iam_role" "aurora_secret_access" {
  name = "${local.name_prefix}-secret-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for Aurora to access Secrets Manager
resource "aws_iam_role_policy" "aurora_secret_access" {
  name = "${local.name_prefix}-secret-access"
  role = aws_iam_role.aurora_secret_access.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [aws_secretsmanager_secret.aurora_credentials.arn]
      }
    ]
  })
}

# Attach the IAM role to the Aurora cluster
resource "aws_rds_cluster_role_association" "aurora_secret_access" {
  db_cluster_identifier = aws_rds_cluster.aurora_cluster.id
  role_arn             = aws_iam_role.aurora_secret_access.arn
  feature_name         = "SecretsManager"
} 