module "vpc" {
  source                      = "../terraform-aws-vpc-2"
  project_name                = var.project_name
  vpc_cidr_block              = var.vpc_cidr_block
  is_peering_required         = var.is_peering_required
  public_subnet_cidr_blocks   = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks  = var.private_subnet_cidr_blocks
  database_subnet_cidr_blocks = var.database_subnet_cidr_blocks
  common_tags                 = var.common_tags
}
