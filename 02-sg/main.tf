module "frontend" {
  source         = "../terraform-aws-sg-2"
  sg_name        = var.frontend_sg_info["sg_name"]
  sg_description = var.frontend_sg_info["sg_description"]
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  project_name   = var.project_name
  environment    = var.environment
  common_tags    = var.common_tags
}

module "backend" {
  source         = "../terraform-aws-sg-2"
  sg_name        = var.backend_sg_info["sg_name"]
  sg_description = var.backend_sg_info["sg_description"]
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  project_name   = var.project_name
  environment    = var.environment
  common_tags    = var.common_tags
}

module "database" {
  source         = "../terraform-aws-sg-2"
  sg_name        = var.database_sg_info["sg_name"]
  sg_description = var.database_sg_info["sg_description"]
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  project_name   = var.project_name
  environment    = var.environment
  common_tags    = var.common_tags
}

module "bastion" {
  source         = "../terraform-aws-sg-2"
  sg_name        = var.bastion_sg_info["sg_name"]
  sg_description = var.bastion_sg_info["sg_description"]
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  project_name   = var.project_name
  environment    = var.environment
  common_tags    = var.common_tags
}

module "vpn" {
  source         = "../terraform-aws-sg-2"
  sg_name        = var.vpn_sg_info["sg_name"]
  sg_description = var.vpn_sg_info["sg_description"]
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  project_name   = var.project_name
  environment    = var.environment
  common_tags    = var.common_tags
  inbound_rules  = var.vpn_sg_inbound_rules
}

module "app_alb" {
  source         = "../terraform-aws-sg-2"
  sg_name        = var.app_alb_sg_info["sg_name"]
  sg_description = var.app_alb_sg_info["sg_description"]
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  project_name   = var.project_name
  environment    = var.environment
  common_tags    = var.common_tags
}

module "web_alb" {
  source         = "../terraform-aws-sg-2"
  sg_name        = var.web_alb_sg_info["sg_name"]
  sg_description = var.web_alb_sg_info["sg_description"]
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  project_name   = var.project_name
  environment    = var.environment
  common_tags    = var.common_tags
}
