############################################
# Route53 Outputs
############################################

# Explanation: Outputs are the nav computer readout
output "obsidian_route53_zone_id" {
  value = local.obsidian_zone_id
}

output "obsidian_app_url_https" {
  value = "https://${var.app_subdomain}.${var.domain_name}"
}

# Apex URL
output "obsidian_apex_url_https" {
  value = "https://${var.domain_name}"
}

# ALB access logs bucket
output "obsidian_alb_logs_bucket_name" {
  value = var.enable_alb_access_logs ? aws_s3_bucket.obsidian_alb_logs_bucket01[0].bucket : null
}

# Coordinates for WAF log destination
output "obsidian_waf_log_destination" {
  value = var.waf_log_destination
}

output "obsidian_waf_cw_log_group_name" {
  value = var.waf_log_destination == "cloudwatch" ? aws_cloudwatch_log_group.obsidian_waf_log_group01[0].name : null
}

output "obsidian_waf_logs_s3_bucket" {
  value = var.waf_log_destination == "s3" ? aws_s3_bucket.obsidian_waf_logs_bucket01[0].bucket : null
}

output "obsidian_waf_firehose_name" {
  value = var.waf_log_destination == "firehose" ? aws_kinesis_firehose_delivery_stream.obsidian_waf_firehose01[0].name : null
}
