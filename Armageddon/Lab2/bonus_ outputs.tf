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

############################################
# Route53 Outputs
############################################

# # Explanation: Outputs are the nav computer readout
# output "obsidian_route53_zone_id" {
#   value = local.obsidian_zone_id
# }

output "obsidian_app_url_https" {
  value = "https://${var.app_subdomain}.${var.domain_name}"
}

# Apex URL
output "obsidian_apex_url_https" {
  value = "https://${var.domain_name}"
}

