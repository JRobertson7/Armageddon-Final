############################################
# Bonus B - Route53 (Hosted Zone + DNS records + ACM validation + ALIAS to ALB)
############################################

locals {
  # Explanation: Obsidian needs a home planet—Route53 hosted zone is your DNS territory.
  obsidian_zone_name = var.domain_name

  # Explanation: Use either Terraform-managed zone or a pre-existing zone ID.
  obsidian_zone_id = (var.manage_route53_in_terraform
    ? aws_route53_zone.obsidian_zone01[0].zone_id
  : var.route53_hosted_zone_id)

  # Explanation: This is the app address that will growl at the galaxy.
  obsidian_app_fqdn = "${var.app_subdomain}.${var.domain_name}"
}

############################################
# Hosted Zone (optional creation)
############################################

# Explanation: A hosted zone is like claiming Kashyyyk in DNS—
# names here become law across the galaxy.
resource "aws_route53_zone" "obsidian_zone01" {
  count = var.manage_route53_in_terraform ? 1 : 0

  name = local.obsidian_zone_name

  tags = {
    Name = "${var.project_name}-zone01"
  }
}

############################################
# ALIAS record: app.<domain> -> ALB
############################################

# Explanation: This is the holographic sign outside the cantina—
# app.obsidian-growl.com points to your ALB.
resource "aws_route53_record" "obsidian_app_alias01" {
  zone_id = local.obsidian_zone_id
  name    = "app" # This is the subdomain
  type    = "A"

  alias {
    name                   = aws_lb.obsidian_alb01.dns_name
    zone_id                = aws_lb.obsidian_alb01.zone_id
    evaluate_target_health = true
  }
}
