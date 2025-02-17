resource "aws_lb" "web_alb" {
  name     = "${var.project_name}-${var.environment}-web-alb"
  internal = false

  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet_ids.value)

  enable_deletion_protection = false

  tags = merge(var.common_tags, var.web_alb_tags, {
    Name = "${var.project_name}-${var.environment}-web-alb"
  })
}

resource "aws_lb_listener" "web_alb" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello from Web ALB</h1>"
      status_code  = "200"
    }
  }
}

module "web_alb_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = var.zone_name

  records = [
    {
      name            = "web-${var.environment}"
      type            = "A"
      allow_overwrite = true
      alias = {
        name    = aws_lb.web_alb.dns_name
        zone_id = aws_lb.web_alb.zone_id
      }
    }
  ]
}
