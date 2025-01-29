# Bastion Host
module "bastion" {
  source    = "terraform-aws-modules/ec2-instance/aws"
  name      = "${var.project_name}-${var.environment}-bastion"
  ami       = data.aws_ami.rhel9.id
  user_data = file("bastion.sh")

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]

  tags = merge(var.common_tags, var.bastion_tags, {
    Name = "${var.project_name}-${var.environment}-bastion"
  })
}
