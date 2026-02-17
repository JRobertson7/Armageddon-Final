# Explanation: Outputs are your mission report—what got built and where to find it.
output "obsidian_vpc_id" {
  value = aws_vpc.obsidian_vpc01.id
}

output "obsidian_public_subnet_ids" {
  value = aws_subnet.obsidian_public_subnets[*].id
}

output "obsidian_private_subnet_ids" {
  value = aws_subnet.obsidian_private_subnets[*].id
}

output "obsidian_ec2_instance_id" {
  value = aws_instance.obsidian_ec201.id
}

output "obsidian_rds_endpoint" {
  value = aws_db_instance.obsidian_rds01.address
}

output "obsidian_sns_topic_arn" {
  value = aws_sns_topic.obsidian_sns_topic01.arn
}

output "obsidian_log_group_name" {
  value = aws_cloudwatch_log_group.obsidian_log_group01.name
}