# Explanation: Outputs are the mission coordinates — where to point your browser and your blasters.
output "obsidian_alb_dns_name" {
  value = aws_lb.obsidian_alb01.dns_name
}

output "obsidian_app_fqdn" {
  value = "${var.app_subdomain}.${var.domain_name}"
}

output "obsidian_target_group_arn" {
  value = aws_lb_target_group.obsidian_tg01.arn
}

# output "obsidian_acm_cert_arn" {
#   value = aws_acm_certificate.obsidian_acm_cert01.arn
# }

output "obsidian_waf_arn" {
  value = var.enable_waf ? aws_wafv2_web_acl.obsidian_waf01[0].arn : null
}

output "obsidian_dashboard_name" {
  value = aws_cloudwatch_dashboard.obsidian_dashboard01.dashboard_name
}

