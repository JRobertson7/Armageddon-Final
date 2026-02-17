data "aws_acm_certificate" "alb_regional_cert" {
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}
