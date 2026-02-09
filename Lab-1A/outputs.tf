output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app.public_ip
}

output "rds_endpoint" {
  description = "RDS MySQL endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "ec2_security_group_id" {
  value = aws_security_group.sg_ec2_lab.id
}

output "rds_security_group_id" {
  value = aws_security_group.sg_rds_lab.id
}
