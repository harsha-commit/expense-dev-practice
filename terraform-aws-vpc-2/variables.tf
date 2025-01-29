variable "project_name" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_cidr_block" {
  type = string
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "common_tags" {
  type = map(any)
}

variable "vpc_tags" {
  type    = map(any)
  default = {}
}

variable "public_subnet_cidr_blocks" {
  type = list(any)
  validation {
    condition     = length(var.public_subnet_cidr_blocks) == 2
    error_message = "Please provide only 2 public subnet CIDR blocks"
  }
}

variable "private_subnet_cidr_blocks" {
  type = list(any)
  validation {
    condition     = length(var.private_subnet_cidr_blocks) == 2
    error_message = "Please provide only 2 private subnet CIDR blocks"
  }
}

variable "database_subnet_cidr_blocks" {
  type = list(any)
  validation {
    condition     = length(var.database_subnet_cidr_blocks) == 2
    error_message = "Please provide only 2 database subnet CIDR blocks"
  }
}

variable "subnet_tags" {
  type    = map(any)
  default = {}
}

variable "igw_tags" {
  type    = map(any)
  default = {}
}

variable "nat_tags" {
  type    = map(any)
  default = {}
}

variable "eip_tags" {
  type    = map(any)
  default = {}
}

variable "rtb_tags" {
  type    = map(any)
  default = {}
}

variable "is_peering_required" {
  type = bool
}

variable "acceptor_vpc_id" {
  type    = string
  default = ""
}

variable "peering_tags" {
  type    = map(any)
  default = {}
}
