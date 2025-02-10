provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.7.0"
}

module "vpc" {
  source       = "git::https://github.com/lroquec/aws-vpc-module.git//?ref=v1.4.0"
  environment  = "prod"
  project_name = "ecommerce"
  accountable  = "platform-team"
  git_repo     = "https://github.com/company/ecommerce-platform"

  vpc_cidr = "10.100.0.0/16"

  vpc_subnet_config = {
    public1 = {
      cidr_block = "10.100.1.0/24"
      public     = true
    }
    public2 = {
      cidr_block = "10.100.2.0/24"
      public     = true
    }
    private1 = {
      cidr_block = "10.100.10.0/24"
    }
    private2 = {
      cidr_block = "10.100.11.0/24"
    }
  }

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