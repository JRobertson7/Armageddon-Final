output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.obsidian_cf01.id
}

output "cloudfront_distribution_domain_name" {
  description = "CloudFront distribution domain name (e.g., d1234.cloudfront.net)"
  value       = aws_cloudfront_distribution.obsidian_cf01.domain_name
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.obsidian_cf01.arn
}

output "cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID (for Route53 alias records)"
  value       = aws_cloudfront_distribution.obsidian_cf01.hosted_zone_id
}

output "cache_policy_api_disabled_id" {
  description = "Cache policy ID for API (caching disabled)"
  value       = aws_cloudfront_cache_policy.obsidian_cache_api_disabled01.id
}

output "cache_policy_static_id" {
  description = "Cache policy ID for static content (aggressive caching)"
  value       = aws_cloudfront_cache_policy.obsidian_cache_static01.id
}

output "origin_request_policy_api_id" {
  description = "Origin request policy ID for API"
  value       = aws_cloudfront_origin_request_policy.obsidian_orp_api01.id
}

output "origin_request_policy_static_id" {
  description = "Origin request policy ID for static"
  value       = aws_cloudfront_origin_request_policy.obsidian_orp_static01.id
}

output "waf_web_acl_id" {
  description = "WAF Web ACL ID (CLOUDFRONT scope)"
  value       = aws_wafv2_web_acl.obsidian_cf_waf01.id
}