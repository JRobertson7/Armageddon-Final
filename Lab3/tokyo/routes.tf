resource "aws_route" "to_sp" {
  count                  = var.saopaulo_vpc_cidr != "" ? 1 : 0
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = var.saopaulo_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}
