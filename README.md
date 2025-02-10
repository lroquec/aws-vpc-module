# AWS VPC Terraform Module

A production-ready Terraform module for creating and managing AWS Virtual Private Cloud (VPC) infrastructure with multi-environment support.

[![Terraform](https://img.shields.io/badge/terraform-%23623CE4.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)

## Overview

This module provides a standardized way to create AWS VPC resources following AWS best practices. It supports:

- Multi-environment VPC deployment (dev, prod, etc.)
- Automatic subnet CIDR calculation
- Public and private subnets across 3 availability zones
- Database and ElastiCache subnet tiers
- Configurable NAT Gateway deployment (single for non-prod, multi-AZ for prod)
- VPC Flow Logs with CloudWatch integration
- Customizable security groups and NACLs
- Kubernetes-ready subnet tagging

## Usage

```hcl
module "vpc" {
  source = "git::https://github.com/lroquec/aws-vpc-module.git//?ref=v1.5.0"
  
  environment  = "prod"
  project_name = "ecommerce"
  accountable  = "platform-team"
  git_repo     = "https://github.com/company/ecommerce-platform"

  vpc_cidr = "10.100.0.0/16"

  create_public_subnets      = true
  create_private_subnets     = true
  create_database_subnets    = true
  create_elasticache_subnets = true
  enable_flow_log            = true

  tags = {
    Project    = "ecommerce"
    CostCenter = "platform"
  }
}
```

## Requirements

- Terraform >= 1.7.0
- AWS Provider ~> 5.0
- AWS Account with appropriate permissions

## Key Features

- **Auto-scaling Network Design**: Automatically calculates subnet CIDRs based on the VPC CIDR
- **Environment-based Configuration**: Adjusts NAT Gateway deployment based on environment
- **Security-First Approach**: Configurable default security groups and flow logs
- **Kubernetes Support**: Includes required tags for AWS Load Balancer Controller

## Project Structure

```
.
├── .github/workflows      # CI/CD workflows
├── examples              # Example implementations
│   ├── basic-usage       # Simple VPC setup
│   └── complete         # Full-featured setup
├── 0-versions.tf        # Provider and version requirements
├── 1-main.tf           # Main VPC configuration
├── 2-variables.tf      # Input variables
└── 3-outputs.tf        # Output definitions
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| environment | Environment name | string | "sandbox" | no |
| project_name | Name of the project | string | "test-project" | no |
| vpc_cidr | CIDR block for VPC | string | "10.0.0.0/16" | no |
| create_public_subnets | Whether to create public subnets | bool | true | no |
| create_private_subnets | Whether to create private subnets | bool | true | no |
| create_database_subnets | Whether to create database subnets | bool | false | no |
| create_elasticache_subnets | Whether to create elasticache subnets | bool | false | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| public_subnets | List of IDs of public subnets |
| private_subnets | List of IDs of private subnets |
| database_subnets | List of IDs of database subnets |
| elasticache_subnets | List of IDs of elasticache subnets |

For more detailed examples, check the basic-usage directory.

For version history, see the CHANGELOG.md.
