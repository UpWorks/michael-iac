# Store database endpoint in SSM Parameter Store
resource "aws_ssm_parameter" "db_endpoint" {
  name        = "/${local.name_prefix}/endpoint"
  description = "Aurora MySQL cluster endpoint"
  type        = "String"
  value       = aws_rds_cluster.aurora_cluster.endpoint

  tags = local.common_tags
}

# Store database reader endpoint in SSM Parameter Store
resource "aws_ssm_parameter" "db_reader_endpoint" {
  name        = "/${local.name_prefix}/reader-endpoint"
  description = "Aurora MySQL cluster reader endpoint"
  type        = "String"
  value       = aws_rds_cluster.aurora_cluster.reader_endpoint

  tags = local.common_tags
}

# Store database port in SSM Parameter Store
resource "aws_ssm_parameter" "db_port" {
  name        = "/${local.name_prefix}/port"
  description = "Aurora MySQL cluster port"
  type        = "String"
  value       = aws_rds_cluster.aurora_cluster.port

  tags = local.common_tags
}

# Store database name in SSM Parameter Store
resource "aws_ssm_parameter" "db_name" {
  name        = "/${local.name_prefix}/database-name"
  description = "Aurora MySQL database name"
  type        = "String"
  value       = aws_rds_cluster.aurora_cluster.database_name

  tags = local.common_tags
}

# Store secret ARN in SSM Parameter Store
resource "aws_ssm_parameter" "secret_arn" {
  name        = "/${local.name_prefix}/secret-arn"
  description = "ARN of the secret in AWS Secrets Manager"
  type        = "String"
  value       = aws_secretsmanager_secret.aurora_credentials.arn

  tags = local.common_tags
} 