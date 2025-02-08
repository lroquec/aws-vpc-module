provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.7.0"
  backend "s3" {
    bucket = "lroquec-tf"
    key    = "test/modules/vpc/terraform.tfstate"
    region = "us-east-1"
    # For DynamoDB locking in production environments
    # dynamodb_table = "terraform-locks"
  }
}

module "vpc" {
  source            = "../../"
  environment       = var.environment
  project_name      = var.project_name
  vpc_cidr          = var.vpc_cidr
  vpc_subnet_config = var.vpc_subnet_config
  tags              = var.tags
}