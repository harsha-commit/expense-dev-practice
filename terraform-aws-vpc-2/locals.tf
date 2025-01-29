locals {
  azs_info = slice(data.aws_availability_zones.this.names, 0, 2)
}
