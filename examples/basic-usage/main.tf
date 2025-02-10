provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.7.0"
}

module "vpc" {
  source = "git::https://github.com/lroquec/aws-vpc-module.git//?ref=v1.5.0" # Use remote module
  # source                 = "../../" # Use local module
  environment            = "dev"
  project_name           = "test-project"
  vpc_cidr               = "10.0.0.0/16"
  create_public_subnets  = true
  create_private_subnets = true
  tags                   = { "OtherTag" = "test-tag" }
}
