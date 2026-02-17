############################################
# TOKYO OUTPUTS — LAB 3A
# These are consumed by São Paulo via remote state
############################################

# --- Transit Gateway ---
output "tokyo_tgw_id" {
  description = "Tokyo Transit Gateway ID (hub)"
  value       = aws_ec2_transit_gateway.shinjuku_tgw.id
}

# --- TGW Peering Attachment ---
output "tgw_peering_attachment_id" {
  description = "TGW peering attachment ID (Tokyo -> Sao Paulo)"
  value       = aws_ec2_transit_gateway_peering_attachment.to_sp.id
}

# --- Networking ---
output "tokyo_vpc_id" {
  description = "Tokyo VPC ID"
  value       = aws_vpc.shinjuku_vpc.id
}

output "tokyo_vpc_cidr" {
  description = "Tokyo VPC CIDR block"
  value       = aws_vpc.shinjuku_vpc.cidr_block
}

# --- Database (Read-only reference) ---
output "rds_endpoint" {
  description = "Tokyo RDS endpoint (PHI stored here only)"
  value       = aws_db_instance.shinjuku_rds.endpoint
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.shinjuku_rds.port
}