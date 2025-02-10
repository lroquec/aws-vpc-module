provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.7.0"
}

module "vpc" {
  source       = "git::https://github.com/lroquec/aws-vpc-module.git//?ref=v1.5.0"  # Use remote module
  # source       = "../../" # Use local module
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

  default_security_group_ingress = [
    {
      from_port   = "443"
      to_port     = "443"
      protocol    = "tcp"
      cidr_blocks = "10.100.0.0/16"
      description = "Internal HTTPS"
    }
  ]

  default_security_group_egress = [
    {
      from_port   = "0"
      to_port     = "0"
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow all outbound"
    }
  ]

  tags = {
    Project    = "ecommerce"
    CostCenter = "platform"
  }
}