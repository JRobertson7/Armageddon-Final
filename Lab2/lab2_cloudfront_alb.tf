############################################
# Lab 2 + Lab 2B: CloudFront in front of ALB
# - Default behavior: API-safe (caching disabled)
# - /static/*: aggressive caching
# - /api/public-feed: honors origin-driven caching (managed policy)
############################################

# Honors: managed origin-driven caching policy
# NOTE: Use the plain name (no "Managed-" prefix) for these newer policies.
# This aligns with AWS naming and avoids common lookup mismatches in tooling. :contentReference[oaicite:4]{index=4}
data "aws_cloudfront_cache_policy" "use_origin_cache_control_headers" {
  name = "UseOriginCacheControlHeaders"
}

resource "aws_cloudfront_distribution" "obsidian_cf01" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "${var.project_name}-cf01"

  origin {
    origin_id   = "${var.project_name}-alb-origin01"
    domain_name = aws_lb.obsidian_alb01.dns_name

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    # Secret origin header (ALB listener rule requires this)
    custom_header {
      name  = "X-Obsidian-Growl"
      value = random_password.obsidian_origin_header_value01.result
    }
  }

  ############################################
  # Default behavior = API-safe default (no caching)
  ############################################
  default_cache_behavior {
    target_origin_id       = "${var.project_name}-alb-origin01"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id          = aws_cloudfront_cache_policy.obsidian_cache_api_disabled01.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.obsidian_orp_api01.id

    compress = true
  }

  ############################################
  # Honors behavior: /api/public-feed (origin-driven caching)
  # CloudFront caches ONLY when origin returns Cache-Control that allows it. :contentReference[oaicite:5]{index=5}
  ############################################
  ordered_cache_behavior {
    path_pattern           = "/api/public-feed"
    target_origin_id       = "${var.project_name}-alb-origin01"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id          = data.aws_cloudfront_cache_policy.use_origin_cache_control_headers.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.obsidian_orp_api01.id

    compress = true
  }

  ############################################
  # /static/* = aggressive caching
  ############################################
  ordered_cache_behavior {
    path_pattern           = "/static/*"
    target_origin_id       = "${var.project_name}-alb-origin01"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id            = aws_cloudfront_cache_policy.obsidian_cache_static01.id
    origin_request_policy_id   = aws_cloudfront_origin_request_policy.obsidian_orp_static01.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.obsidian_rsp_static01.id

    compress = true
  }

  ############################################
  # WAF at CloudFront edge
  ############################################
  web_acl_id = aws_wafv2_web_acl.obsidian_cf_waf01.arn

  ############################################
  # Aliases (apex + app subdomain)
  ############################################
  # aliases = [
  #   var.domain_name,
  #   "${var.app_subdomain}.${var.domain_name}"
  # ]

  ############################################
  # Geo-restriction (none applied)
  ############################################
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  ############################################
  # Viewer cert MUST be in us-east-1
  ############################################
  viewer_certificate {
    cloudfront_default_certificate = true
  }

}

# CloudFront cert lookup (us-east-1)
data "aws_acm_certificate" "obsidian_existing_cert" {
  provider    = aws.use1
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

# Removed invalid standalone viewer_certificate block

