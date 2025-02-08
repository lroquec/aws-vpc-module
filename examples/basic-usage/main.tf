provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.7.0"
}

module "vpc" {
  source            = "../../"
  environment       = var.environment
  project_name      = var.project_name
  vpc_cidr          = var.vpc_cidr
  vpc_subnet_config = var.vpc_subnet_config
  tags              = var.tags
}