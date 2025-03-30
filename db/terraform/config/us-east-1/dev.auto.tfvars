# Cluster Configuration
cluster_identifier = "dev-aurora-mysql"
database_name     = "devdb"
master_username   = "admin"
master_password   = "CHANGE_THIS_PASSWORD_IN_PRODUCTION"  # Please change this in production!

# Instance Configuration
instance_count    = 2
instance_class    = "db.t3.medium"

# Network Configuration
vpc_id            = "vpc-0123456789abcdef0"  # Replace with your VPC ID
subnet_ids        = [
  "subnet-0123456789abcdef1",  # Replace with your subnet IDs
  "subnet-0123456789abcdef2",
  "subnet-0123456789abcdef3"
]

# Security
allowed_cidr_blocks = [
  "10.0.0.0/8",     # Example: Allow access from internal network
  "172.16.0.0/12",  # Example: Allow access from internal network
  "192.168.0.0/16"  # Example: Allow access from internal network
]

# Backup and Maintenance
backup_retention_period = 7
preferred_backup_window = "03:00-04:00"
preferred_maintenance_window = "Mon:04:00-Mon:05:00"

# Region
aws_region = "us-west-2" 