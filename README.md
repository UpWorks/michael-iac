# Aurora MySQL Infrastructure as Code

This repository contains Terraform configurations for deploying an AWS Aurora MySQL database cluster with automated secret management and security best practices.

## Infrastructure Overview

The infrastructure includes:
- AWS Aurora MySQL cluster with multiple instances for high availability
- AWS Secrets Manager for credential management
- IAM roles and policies for secure access
- Security groups and subnet groups for network isolation
- CloudWatch logging enabled
- Automated backups configured

## Directory Structure

```
db/
└── terraform/
    ├── main.tf           # Main infrastructure configuration
    ├── variables.tf      # Input variables
    ├── outputs.tf        # Output values
    ├── provider.tf       # AWS provider configuration
    ├── data.tf          # Data sources
    ├── locals.tf        # Local variables and computed values
    ├── paramstore.tf    # SSM Parameter Store configurations
    └── config/
        └── us-east-1/
            ├── dev.auto.tfvars    # Development environment variables
            └── dev_tfe_backend.config  # Terraform Enterprise workspace configuration
```

## Prerequisites

1. AWS Account with appropriate permissions
2. Terraform Enterprise access
3. VPC and subnet configuration in AWS
4. AWS credentials configured

## Required Variables

The following variables must be set in your environment or tfvars file:

```hcl
cluster_identifier     # Unique identifier for the Aurora cluster
database_name         # Name of the database to create
master_username       # Master username for the database
master_password       # Master password for the database
vpc_id               # VPC ID where the cluster will be deployed
subnet_ids           # List of subnet IDs for the DB subnet group
product_name         # Product name for resource tagging
env_name             # Environment name (e.g., dev, prod)
env_type             # Environment type
aws_region           # AWS region for deployment
```

## Deployment Instructions

### Using Terraform Enterprise

1. **Configure Terraform Enterprise Workspace**
   - Create a new workspace named `devlake-db-iac-dev1`
   - Set the working directory to `db/terraform`
   - Configure VCS integration with this repository

2. **Configure Variables**
   - Add all required variables in the Terraform Enterprise workspace
   - Mark sensitive variables (like `master_password`) as sensitive
   - Set environment variables for AWS credentials if not using workspace-specific credentials

3. **Configure Backend**
   - The workspace is configured to use the backend configuration from `config/us-east-1/dev_tfe_backend.config`
   - The workspace name is set to `devlake-db-iac-dev1`

4. **Deploy Infrastructure**
   - Queue a plan in Terraform Enterprise
   - Review the plan output
   - Apply the changes if the plan looks correct

### Local Development

1. **Initialize Terraform**
   ```bash
   cd db/terraform
   terraform init
   ```

2. **Review Changes**
   ```bash
   terraform plan -var-file="config/us-east-1/dev.auto.tfvars"
   ```

3. **Apply Changes**
   ```bash
   terraform apply -var-file="config/us-east-1/dev.auto.tfvars"
   ```

## Security Features

1. **Credential Management**
   - Master credentials stored in AWS Secrets Manager
   - IAM role-based access to secrets
   - Automatic secret rotation capability

2. **Network Security**
   - VPC isolation
   - Security group with configurable CIDR blocks
   - Private subnet placement

3. **Encryption**
   - Storage encryption enabled
   - Secure credential storage
   - IAM authentication support

## Maintenance

### Backup Configuration
- Automated backups enabled
- 7-day retention period (configurable)
- Backup window: 03:00-04:00 UTC (configurable)

### Maintenance Window
- Weekly maintenance window: Monday 04:00-05:00 UTC (configurable)
- CloudWatch logging enabled for:
  - Audit logs
  - Error logs
  - General logs
  - Slow query logs

## Outputs

The following outputs are available:
- `cluster_endpoint`: The cluster endpoint
- `cluster_reader_endpoint`: The cluster reader endpoint
- `cluster_identifier`: The cluster identifier
- `cluster_port`: The cluster port
- `database_name`: The database name
- `master_username`: The master username
- `security_group_id`: The security group ID
- `secret_arn`: The ARN of the secret in AWS Secrets Manager

## Best Practices

1. **Resource Naming**
   - Resources follow a consistent naming convention
   - Includes environment and region information
   - Uses local variables for consistency

2. **Tagging**
   - All resources are tagged with:
     - Environment
     - Project
     - ManagedBy
     - Owner
     - CostCenter

3. **Security**
   - Least privilege principle for IAM roles
   - Encrypted storage
   - Secure credential management
   - Network isolation

## Troubleshooting

1. **Common Issues**
   - VPC/Subnet configuration issues
   - IAM permission issues
   - Secret rotation failures

2. **Logs**
   - Check CloudWatch logs for detailed information
   - Review Terraform Enterprise run logs
   - Monitor Aurora cluster metrics

## Support

For support or questions, please contact the platform team or create an issue in this repository.
