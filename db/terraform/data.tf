# Get the current AWS region
data "aws_region" "current" {}

# Get the current AWS account ID
data "aws_caller_identity" "current" {}

# Get the current AWS IAM account alias
data "aws_iam_account_alias" "current" {}

# Get the current AWS partition
data "aws_partition" "current" {}

# Get the VPC details
data "aws_vpc" "selected" {
  id = var.vpc_id
}

# Get subnet details for given vpc id
data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }

  filter {
    name   = "tag:name"
    values = [var.private_subnet_name_filter]
  }
}

# Get the latest Aurora MySQL engine version
data "aws_rds_engine_version" "aurora_mysql" {
  engine             = "aurora-mysql"
  preferred_versions = [var.engine_version]
} 