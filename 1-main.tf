data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  public_subnets_cidr  = [for k, v in var.vpc_subnet_config : v.cidr_block if v.public]
  private_subnets_cidr = [for k, v in var.vpc_subnet_config : v.cidr_block if !v.public]
  num_azs_needed       = max(length(local.public_subnets_cidr), length(local.private_subnets_cidr))

  available_azs = data.aws_availability_zones.available.names

  azs = [for i in range(local.num_azs_needed) : element(local.available_azs, i)]

  database_subnets    = var.create_database_subnets ? [for i in range(2) : cidrsubnet(var.vpc_cidr, 8, i + 10)] : []
  elasticache_subnets = var.create_elasticache_subnets ? [for i in range(2) : cidrsubnet(var.vpc_cidr, 8, i + 20)] : []

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
  version = "~> 5.0"

  name = "${var.environment}-${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets_cidr
  public_subnets  = local.public_subnets_cidr

  enable_nat_gateway   = true
  single_nat_gateway   = var.environment != "prod"
  enable_dns_hostnames = true
  enable_dns_support   = true

  database_subnets    = local.database_subnets
  elasticache_subnets = local.elasticache_subnets

  map_public_ip_on_launch = true

  enable_flow_log                                 = var.enable_flow_log
  flow_log_cloudwatch_log_group_retention_in_days = var.enable_flow_log ? 7 : 0

  manage_default_security_group  = true
  default_security_group_ingress = var.default_security_group_ingress
  default_security_group_egress  = var.default_security_group_egress

  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = 1
    "kubernetes.io/cluster/${var.project_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = 1
    "kubernetes.io/cluster/${var.project_name}" = "shared"
  }

  tags = merge(
    var.tags, local.common_tags
  )
}
