module "vpn" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name   = "${var.project_name}-${var.environment}-vpn"
  ami    = data.aws_ami.openvpn.id

  key_name = aws_key_pair.this.key_name

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]

  tags = merge(var.common_tags, var.vpn_tags, {
    Name = "${var.project_name}-${var.environment}-vpn"
  })
}

resource "aws_key_pair" "this" {
  key_name   = "openvpn"
  public_key = file("publickey")
}
