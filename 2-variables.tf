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

variable "vpc_subnet_config" {
  description = "Configuration for VPC subnets"
  type = map(object({
    cidr_block = string
    public     = optional(bool, false)
  }))
  default = {
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
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
