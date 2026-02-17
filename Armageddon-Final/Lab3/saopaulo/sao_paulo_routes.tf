# --- Route Tokyo traffic through TGW ---
resource "aws_route" "sp_to_tokyo" {
  route_table_id         = aws_route_table.liberdade_private.id
  destination_cidr_block = data.terraform_remote_state.tokyo.outputs.tokyo_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.liberdade_tgw.id
}
