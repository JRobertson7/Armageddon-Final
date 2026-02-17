# --- Transit Gateway (Hub) ---
resource "aws_ec2_transit_gateway" "shinjuku_tgw" {
  description = "Tokyo TGW - Data Authority Hub"

  tags = {
    Name = "shinjuku-tgw"
  }
}

# --- Attach Tokyo VPC to TGW ---
resource "aws_ec2_transit_gateway_vpc_attachment" "shinjuku_vpc_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.shinjuku_tgw.id
  vpc_id             = aws_vpc.shinjuku_vpc.id
  subnet_ids         = aws_subnet.shinjuku_private[*].id

  tags = {
    Name = "shinjuku-vpc-attach"
  }
}

# --- Peering Request to Sao Paulo ---
resource "aws_ec2_transit_gateway_peering_attachment" "tokyo_to_sp" {
  transit_gateway_id      = aws_ec2_transit_gateway.shinjuku_tgw.id
  peer_transit_gateway_id = var.saopaulo_tgw_id
  peer_region             = "sa-east-1" # Sao Paulo region
  tags = {
    Name        = "shinjuku-to-liberdade"
    Environment = "lab"
  }
}