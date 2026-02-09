# --- Route Sao Paulo traffic back through TGW ---
resource "aws_route" "tokyo_to_sp" {
  route_table_id         = aws_route_table.shinjuku_private.id
  destination_cidr_block = var.saopaulo_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.shinjuku_tgw.id
}
