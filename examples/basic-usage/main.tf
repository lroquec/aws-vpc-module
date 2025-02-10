provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.7.0"
}

module "vpc" {
  source       = "git::https://github.com/lroquec/aws-vpc-module.git//?ref=v1.4.0"
  environment  = "dev"
  project_name = "test-project"
  vpc_cidr     = "10.0.0.0/16"
  vpc_subnet_config = {
    subnet1 = {
      cidr_block = "10.0.1.0/24"
      public     = true
    }
    subnet2 = {
      cidr_block = "10.0.2.0/24"
      public     = true
    }
    subnet3 = {
      cidr_block = "10.0.3.0/24"
      public     = false
    }
    subnet4 = {
      cidr_block = "10.0.4.0/24"
      public     = false
    }
  }
  tags = { "OtherTag" = "test-tag" }
}