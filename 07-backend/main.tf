module "backend" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name   = "${var.project_name}-${var.environment}-backend"
  ami    = data.aws_ami.rhel9.id

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]
  subnet_id              = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]

  tags = merge(var.common_tags, var.backend_tags, {
    Name = "${var.project_name}-${var.environment}-backend"
  })
}

module "backend_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = var.zone_name

  records = [
    {
      name = "backend-${var.environment}"
      type = "A"
      ttl  = 1
      records = [
        module.backend.private_ip
      ]
    },
  ]
}

resource "null_resource" "backend" {

  triggers = {
    instance_id = module.backend.id
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = module.backend.private_ip
  }

  provisioner "file" {
    source      = "backend.sh"
    destination = "/tmp/backend.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/backend.sh",
      "sudo sh /tmp/backend.sh backend ${var.environment} ${var.app_version}"
    ]
  }
}

resource "aws_ec2_instance_state" "backend" {
  instance_id = module.backend.id
  state       = "stopped"
  depends_on  = [null_resource.backend]
}

resource "aws_ami_from_instance" "backend" {
  name               = "${var.project_name}-${var.environment}-backend-ami"
  source_instance_id = module.backend.id
  depends_on         = [aws_ec2_instance_state.backend]
}

resource "null_resource" "backend_delete" {
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.backend.id}"
  }
  depends_on = [aws_ami_from_instance.backend]
}

resource "aws_lb_target_group" "backend" {
  name     = "${var.project_name}-${var.environment}-backend-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 15
    matcher             = "200-299"
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    timeout             = 10
  }

  depends_on = [null_resource.backend_delete]
}

resource "aws_launch_template" "backend" {
  name     = "${var.project_name}-${var.environment}-backend-launch-template"
  image_id = aws_ami_from_instance.backend.id

  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  update_default_version               = true

  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-${var.environment}-backend-launch-template"
    }
  }

  depends_on = [aws_lb_target_group.backend]
}

resource "aws_autoscaling_group" "backend" {
  name                      = "${var.project_name}-${var.environment}-backend-asg"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  target_group_arns         = [aws_lb_target_group.backend.arn]
  vpc_zone_identifier       = split(",", data.aws_ssm_parameter.private_subnet_ids.value)

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Project"
    value               = "Expense"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = true
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-backend-asg"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  depends_on = [aws_launch_template.backend]
}

resource "aws_autoscaling_policy" "backend" {
  name        = "${var.project_name}-${var.environment}-backend-asg-policy"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
  autoscaling_group_name = aws_autoscaling_group.backend.name
}

resource "aws_lb_listener_rule" "backend" {
  listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    host_header {
      values = ["backend.app-${var.environment}.${var.zone_name}"]
    }
  }
}

