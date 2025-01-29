variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project     = "Expense"
    Environment = "dev"
    Terraform   = true
  }
}

variable "app_alb_tags" {
  default = {}
}

variable "zone_name" {
  default = "harshadevops.site"
}
