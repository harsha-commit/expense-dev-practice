data "aws_ssm_parameter" "database_sg_id" {
  name = "/${var.project_name}/${var.environment}/database_sg_id"
}

data "aws_ssm_parameter" "database_subnet_group_id" {
  name = "/${var.project_name}/${var.environment}/database_subnet_group_id"
}

data "aws_route53_zone" "this" {
  name = "harshadevops.site"
}
