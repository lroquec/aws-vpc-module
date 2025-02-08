# AWS VPC Terraform Module

A reusable Terraform module for creating and managing AWS Virtual Private Cloud (VPC) infrastructure.

[![Terraform](https://img.shields.io/badge/terraform-%23623CE4.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)

## Overview

This module provides a standardized way to create AWS VPC resources with best practices and configurable options. It supports creating:

- VPC with customizable CIDR blocks
- Public and private subnets across multiple availability zones
- NAT Gateways for private subnet internet access
- VPC Endpoints for AWS services
- Network ACLs and Security Groups
- Route tables and routing rules

## Usage

```hcl
module "vpc" {
  source = "github.com/lroquec/aws-vpc-module"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-1a", "us-west-1b", "us-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

## Files Structure

- 0-versions.tf - Provider and terraform version configurations
- 1-main.tf - Main VPC resources definition
- 2-variables.tf - Input variables declaration
- 3-outputs.tf - Output values
- basic-usage - Example implementations

## Requirements

- Terraform >= 1.7.0
- AWS Provider
- AWS Account and configured credentials

For more detailed examples, check the basic-usage directory.

For version history, see the CHANGELOG.md.
