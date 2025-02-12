data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  # Get 3 availability zones
  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  # Calculate subnet CIDRs based on VPC CIDR
  public_subnet_cidrs = var.create_public_subnets ? [
    for i in range(3) : cidrsubnet(var.vpc_cidr, 8, i)
  ] : []

  private_subnet_cidrs = var.create_private_subnets ? [
    for i in range(3) : cidrsubnet(var.vpc_cidr, 7, i + 16)
  ] : []

  database_subnet_cidrs = var.create_database_subnets ? [
    for i in range(3) : cidrsubnet(var.vpc_cidr, 10, i + 128)
  ] : []

  elasticache_subnet_cidrs = var.create_elasticache_subnets ? [
    for i in range(3) : cidrsubnet(var.vpc_cidr, 10, i + 144)
  ] : []

  # Common tags for all resources
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      ManagedBy   = "terraform"
      Accountable = var.accountable
      Repo        = var.git_repo
    }
  )
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"

  name = "${var.environment}-${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  public_subnets  = local.public_subnet_cidrs
  private_subnets = local.private_subnet_cidrs

  database_subnets    = local.database_subnet_cidrs
  elasticache_subnets = local.elasticache_subnet_cidrs

  enable_nat_gateway   = var.create_private_subnets
  single_nat_gateway   = var.environment != "prod"
  enable_dns_hostnames = true
  enable_dns_support   = true

  map_public_ip_on_launch = true

  enable_flow_log                                 = var.enable_flow_log
  flow_log_cloudwatch_log_group_retention_in_days = var.enable_flow_log ? 7 : 0

  manage_default_security_group = true

  public_subnet_tags      = var.create_public_subnets ? var.public_subnet_tags : {}
  private_subnet_tags     = var.create_private_subnets ? var.private_subnet_tags : {}
  database_subnet_tags    = var.create_database_subnets ? var.database_subnet_tags : {}
  elasticache_subnet_tags = var.create_elasticache_subnets ? var.elasticache_subnet_tags : {}

  tags = local.common_tags
}

resource "aws_security_group" "default" {
  vpc_id = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.custom_ports
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = ingress.value
    }
  }

  tags = local.common_tags
}