variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "sg_name" {
  type = string
}

variable "sg_description" {
  type = string
}

variable "inbound_rules" {
  type    = list(any)
  default = []
}

variable "outbound_rules" {
  type = list(any)
  default = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "vpc_id" {
  type = string
}

variable "common_tags" {
  type = map(any)
}

variable "sg_tags" {
  type    = map(any)
  default = {}
}
