############################################
# SAO PAULO OUTPUTS — LAB 3A
# Used for verification & operational clarity
############################################

# --- Transit Gateway ---
output "saopaulo_tgw_id" {
  description = "Sao Paulo Transit Gateway ID (spoke)"
  value       = aws_ec2_transit_gateway.liberdade_tgw.id
}

# --- Networking ---
output "saopaulo_vpc_id" {
  description = "Sao Paulo VPC ID"
  value       = aws_vpc.liberdade_vpc.id
}

output "saopaulo_vpc_cidr" {
  description = "Sao Paulo VPC CIDR block"
  value       = aws_vpc.liberdade_vpc.cidr_block
}

# --- Application ---
output "app_instance_id" {
  description = "Stateless application EC2 instance ID"
  value       = aws_instance.liberdade_app.id
}

output "app_private_ip" {
  description = "Private IP of Sao Paulo app instance"
  value       = aws_instance.liberdade_app.private_ip
}
