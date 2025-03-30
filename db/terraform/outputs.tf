output "cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.aurora_cluster.endpoint
}

output "cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster.aurora_cluster.reader_endpoint
}

output "cluster_identifier" {
  description = "The cluster identifier"
  value       = aws_rds_cluster.aurora_cluster.cluster_identifier
}

output "cluster_port" {
  description = "The cluster port"
  value       = aws_rds_cluster.aurora_cluster.port
}

output "database_name" {
  description = "The database name"
  value       = aws_rds_cluster.aurora_cluster.database_name
}

output "master_username" {
  description = "The master username"
  value       = aws_rds_cluster.aurora_cluster.master_username
}

output "security_group_id" {
  description = "The security group ID"
  value       = aws_security_group.aurora.id
}

output "secret_arn" {
  description = "The ARN of the secret in AWS Secrets Manager"
  value       = aws_secretsmanager_secret.aurora_credentials.arn
} 