############################################
# Lab 2B - Cache + Origin Request + Response Headers Policies
############################################

# 1) Static cache policy (aggressive)
resource "aws_cloudfront_cache_policy" "obsidian_cache_static01" {
  name        = "${var.project_name}-cache-static01"
  comment     = "Aggressive caching for /static/*"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config { cookie_behavior = "none" }
    query_strings_config { query_string_behavior = "none" }
    headers_config { header_behavior = "none" }
  }
}

# 2) API cache policy (safe default: caching disabled)
resource "aws_cloudfront_cache_policy" "obsidian_cache_api_disabled01" {
  name        = "${var.project_name}-cache-api-disabled01"
  comment     = "Safe default for APIs: caching disabled"
  default_ttl = 0
  max_ttl     = 0
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config { cookie_behavior = "none" }
    query_strings_config { query_string_behavior = "none" }
    headers_config { header_behavior = "none" }
  }
}

resource "aws_cloudfront_origin_request_policy" "obsidian_orp_api01" {
  name    = "${var.project_name}-orp-api01"
  comment = "Forward required values for API to origin"

  cookies_config { cookie_behavior = "all" }
  query_strings_config { query_string_behavior = "all" }

  headers_config {
    header_behavior = "whitelist"
    headers {
      items = [
        "Content-Type",
        "Accept",
        "Origin",
        "Host"
      ]
    }
  }
}

# 4) Origin request policy for static (minimal)
resource "aws_cloudfront_origin_request_policy" "obsidian_orp_static01" {
  name    = "${var.project_name}-orp-static01"
  comment = "Minimal forwarding for static assets"

  cookies_config { cookie_behavior = "none" }
  query_strings_config { query_string_behavior = "none" }
  headers_config { header_behavior = "none" }
}

# 5) Response headers policy for static (optional but nice)
resource "aws_cloudfront_response_headers_policy" "obsidian_rsp_static01" {
  name    = "${var.project_name}-rsp-static01"
  comment = "Static responses: explicit cache-control"

  custom_headers_config {
    items {
      header   = "Cache-Control"
      override = true
      value    = "public, max-age=86400, immutable"
    }
  }
}

