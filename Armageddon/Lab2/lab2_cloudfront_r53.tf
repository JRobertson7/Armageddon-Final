resource "aws_route53_zone" "obsidian_zone01" {
  name = var.domain_name
}

locals {
  obsidian_zone_id = (var.manage_route53_in_terraform
    ? aws_route53_zone.obsidian_zone01.zone_id
  : var.route53_hosted_zone_id)
}

resource "aws_route53_record" "obsidian_apex01" {
  zone_id = local.obsidian_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.obsidian_cf01.domain_name
    zone_id                = aws_cloudfront_distribution.obsidian_cf01.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "obsidian_app_subdomain01" {
  zone_id = local.obsidian_zone_id
  name    = "${var.app_subdomain}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.obsidian_cf01.domain_name
    zone_id                = aws_cloudfront_distribution.obsidian_cf01.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "obsidian_apex_aaaa01" {
  zone_id = local.obsidian_zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.obsidian_cf01.domain_name
    zone_id                = aws_cloudfront_distribution.obsidian_cf01.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "obsidian_app_subdomain_aaaa01" {
  zone_id = local.obsidian_zone_id
  name    = "${var.app_subdomain}.${var.domain_name}"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.obsidian_cf01.domain_name
    zone_id                = aws_cloudfront_distribution.obsidian_cf01.hosted_zone_id
    evaluate_target_health = false
  }
}