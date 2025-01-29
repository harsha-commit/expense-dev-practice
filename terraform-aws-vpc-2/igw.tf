resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, var.igw_tags, {
    Name = "${var.project_name}-${var.environment}-igw"
  })
}
