variable "role_mapping" {
  description = "The role mapping for the resources"
  type        = map(any)
  default = {} #TODO: Add the role mapping
}

variable "product_name" {}

variable "env_name" {}

variable "env_type" {}

variable "aws_region" {}

variable "backup" {}

variable "vpc_name_filter" {
  description = "The name filter for the VPC"
  type        = string
  default     = "vpc1"
}

variable "private_subnet_name_filter" {
  description = "The name filter for the private subnets"
  type        = string
  default     = "private*"
}

variable "resource_suffix" {
  description = "The suffix for the resource name"
  type        = string
  default     = "v1"
}

variable "cluster_identifier" {
  description = "The cluster identifier"
  type        = string
}

variable "engine_version" {
  description = "The database engine version"
  type        = string
  default     = "8.0.mysql_aurora.3.04.0"
}

variable "database_name" {
  description = "Name of the database to create"
  type        = string
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
}

variable "master_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "instance_count" {
  description = "Number of Aurora instances to create"
  type        = number
  default     = 2
}

variable "instance_class" {
  description = "The instance class to use"
  type        = string
  default     = "db.t3.medium"
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to connect to the database"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "03:00-04:00"
}

variable "preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur"
  type        = string
  default     = "Mon:04:00-Mon:05:00"
}

variable "global_cluster_enabled" {
  description = "Whether to enable global database feature for the Aurora cluster"
  type        = bool
  default     = false
}

variable "default_tags" {
  description = "The default tags for the resources"
  type        = map(string)
}
