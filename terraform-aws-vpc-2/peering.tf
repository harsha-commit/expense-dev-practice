resource "aws_vpc_peering_connection" "this" {
  count       = var.is_peering_required ? 1 : 0
  peer_vpc_id = (var.acceptor_vpc_id == "") ? data.aws_vpc.default.id : var.acceptor_vpc_id
  vpc_id      = aws_vpc.main.id
  auto_accept = var.acceptor_vpc_id == "" ? true : false
  tags = merge(var.common_tags, var.peering_tags, {
    Name = "${var.project_name}-${var.environment}-peering"
  })
}
