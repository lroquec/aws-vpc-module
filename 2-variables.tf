variable "environment" {
  description = "Environment name"
  type        = string
  default     = "sandbox"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "test-project"
}

variable "git_repo" {
  description = "Git repo for consumer APP"
  type        = string
  default     = "https://github.com/lroquec/devops-simple"
}

variable "accountable" {
  description = "Name of the team accountable for the project"
  type        = string
  default     = "devops-team"
}
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "create_public_subnets" {
  description = "Whether to create public subnets"
  type        = bool
  default     = true
}

variable "create_private_subnets" {
  description = "Whether to create private subnets"
  type        = bool
  default     = true
}

variable "create_database_subnets" {
  description = "Whether to create database subnets"
  type        = bool
  default     = false
}

variable "create_elasticache_subnets" {
  description = "Whether to create elasticache subnets"
  type        = bool
  default     = false
}

variable "public_subnet_tags" {
  description = "Tags for public subnets"
  type        = map(string)
  default = {
    "kubernetes.io/role/elb" = "1"
    Type                     = "public"
  }
}

variable "private_subnet_tags" {
  description = "Tags for private subnets"
  type        = map(string)
  default = {
    "kubernetes.io/role/internal-elb" = "1"
    Type                              = "private"
  }
}

variable "database_subnet_tags" {
  description = "Tags for database subnets"
  type        = map(string)
  default     = {}
}

variable "elasticache_subnet_tags" {
  description = "Tags for elasticache subnets"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_flow_log" {
  description = "Whether to enable VPC Flow Logs"
  type        = bool
  default     = false
}

variable "custom_ports" {
  description = "List of custom ports to open in the default security group"
  type        = map(any)
  default = {
    80  = ["0.0.0.0/0"]
    443 = ["0.0.0.0/0"]
  }
}
