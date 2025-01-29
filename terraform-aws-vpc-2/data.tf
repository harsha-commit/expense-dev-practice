data "aws_availability_zones" "this" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true
}
