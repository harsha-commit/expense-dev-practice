variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project   = "Expense"
    Terraform = true
  }
}

variable "backend_tags" {
  default = {}
}

variable "zone_name" {
  default = "harshadevops.site"
}
