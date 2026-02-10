resource "aws_acm_certificate" "cf_cert_use1" {
  provider          = aws.use1
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "${var.app_subdomain}.${var.domain_name}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Only build Route53 validation records if we're managing Route53 here
locals {
  cf_cert_dvo = var.manage_route53_in_terraform ? {
    for dvo in aws_acm_certificate.cf_cert_use1.domain_validation_options :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  } : {}
}

resource "aws_route53_record" "cf_cert_validation" {
  for_each = local.cf_cert_dvo

  zone_id = var.route53_hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cf_cert_use1_validation" {
  provider        = aws.use1
  certificate_arn = aws_acm_certificate.cf_cert_use1.arn

  validation_record_fqdns = var.manage_route53_in_terraform ? [
    for record in aws_route53_record.cf_cert_validation : record.fqdn
  ] : []
}

