# --- Transit Gateway (Spoke) ---
resource "aws_ec2_transit_gateway" "liberdade_tgw" {
  description = "Sao Paulo TGW - Compute Spoke"

  tags = {
    Name = "liberdade-tgw"
  }
}

# --- Accept Tokyo Peering ---
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "accept_tokyo" {
  transit_gateway_attachment_id = data.terraform_remote_state.tokyo.outputs.tgw_peering_attachment_id

  tags = {
    Name = "liberdade-accepts-shinjuku"
  }
}

# --- Attach Sao Paulo VPC ---
resource "aws_ec2_transit_gateway_vpc_attachment" "liberdade_vpc_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.liberdade_tgw.id
  vpc_id             = aws_vpc.liberdade_vpc.id
  subnet_ids         = aws_subnet.liberdade_private[*].id

  tags = {
    Name = "liberdade-vpc-attach"
  }
}
