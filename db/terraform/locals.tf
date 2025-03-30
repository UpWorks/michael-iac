locals {

    subnet_ids = data.aws_subnets.private_subnets.ids
    db_name = lower("${var.product_name}${var.env.name}")

    master_username_alias = lower("ap_master_${local.default_tags["usage-id"]}_${local.db_name}")
    friendly_alias = lower("${local.default_tags["usage-id"]}_${local.db_name}")

    # Resource naming convention
    name_prefix = "${var.cluster_identifier}-${data.aws_region.current.name}"

    # Security group name
    security_group_name = "${local.name_prefix}-aurora-sg"

    # Subnet group name
    subnet_group_name = "${local.name_prefix}-subnet-group"

    # Secret name
    secret_name = "${local.name_prefix}-credentials"

    # IAM role name
    iam_role_name = "${local.name_prefix}-secret-access"

    # Compute resource names
    cluster_name = local.name_prefix
    instance_names = [for i in range(var.instance_count) : "${local.name_prefix}-${i + 1}"]

    # VPC and subnet information
    vpc_cidr = data.aws_vpc.selected.cidr_block
    subnet_cidrs = data.aws_subnets.selected.ids

    #default_tags
    default_tags = {
    "usage-id" = ""
    "cost-center" = ""
    "toc" = ""
    "exp-date" = "99-00-9999"
    "sd-period" = "na"
    "env-type" = "var.env_type"
    "env-name" = "var.env_name"
    "backup" = "var.backup"
    }
}
