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

variable "frontend_sg_info" {
  default = {
    sg_name        = "frontend"
    sg_description = "SG for Frontend Instances"
  }
}

variable "backend_sg_info" {
  default = {
    sg_name        = "backend"
    sg_description = "SG for Backend Instances"
  }
}

variable "database_sg_info" {
  default = {
    sg_name        = "database"
    sg_description = "SG for Database Instances"
  }
}

variable "bastion_sg_info" {
  default = {
    sg_name        = "bastion"
    sg_description = "SG for Bastion Instances"
  }
}

variable "ansible_sg_info" {
  default = {
    sg_name        = "ansible"
    sg_description = "SG for Ansible Instances"
  }
}

variable "vpn_sg_info" {
  default = {
    sg_name        = "vpn"
    sg_description = "SG for VPN Instances"
  }
}

variable "app_alb_sg_info" {
  default = {
    sg_name        = "app_alb"
    sg_description = "SG for App ALB Instances"
  }
}

variable "web_alb_sg_info" {
  default = {
    sg_name        = "web_alb"
    sg_description = "SG for Web ALB Instances"
  }
}

variable "vpn_sg_inbound_rules" {
  default = [{
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 1194
      to_port     = 1194
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
