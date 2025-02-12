provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.7.0"
}

module "vpc" {
  source = "git::https://github.com/lroquec/aws-vpc-module.git//?ref=v1.5.0" # Use remote module
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

  tags = {
    Project    = "ecommerce"
    CostCenter = "platform"
  }
}