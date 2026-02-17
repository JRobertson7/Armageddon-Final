############################################
# Bonus B - Route53 Zone Apex + ALB Access Logs to S3
############################################

############################################
# Data sources
############################################

data "aws_region" "current" {}

data "aws_elb_service_account" "this" {}

############################################
# Route53: Zone Apex (root domain) -> ALB
############################################

# Explanation: The zone apex is the throne room—obsidian-growl.com itself should lead to the ALB.
resource "aws_route53_record" "obsidian_apex_alias01" {
  zone_id = local.obsidian_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.obsidian_alb01.dns_name
    zone_id                = aws_lb.obsidian_alb01.zone_id
    evaluate_target_health = true
  }
}

############################################
# S3 bucket for ALB access logs
############################################

# Explanation: This bucket is Obsidian’s log vault—every visitor to the ALB leaves footprints here.
resource "aws_s3_bucket" "obsidian_alb_logs_bucket01" {
  count = var.enable_alb_access_logs ? 1 : 0

  bucket = "${var.project_name}-alb-logs-${data.aws_caller_identity.obsidian_self01.account_id}"

  tags = {
    Name = "${var.project_name}-alb-logs-bucket01"
  }
}

# Explanation: Block public access—Obsidian does not publish the ship’s black box to the galaxy.
resource "aws_s3_bucket_public_access_block" "obsidian_alb_logs_pab01" {
  count = var.enable_alb_access_logs ? 1 : 0

  bucket                  = aws_s3_bucket.obsidian_alb_logs_bucket01[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Explanation: Ownership controls keep log delivery clean—no ACL chaos.
resource "aws_s3_bucket_ownership_controls" "obsidian_alb_logs_owner01" {
  count = var.enable_alb_access_logs ? 1 : 0

  bucket = aws_s3_bucket.obsidian_alb_logs_bucket01[0].id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

############################################
# S3 bucket policy for ALB access logs
############################################

# Explanation: ALB is allowed to write logs, but only securely and only where expected.
resource "aws_s3_bucket_policy" "obsidian_alb_logs_policy01" {
  count = var.enable_alb_access_logs ? 1 : 0

  bucket = aws_s3_bucket.obsidian_alb_logs_bucket01[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # Deny non-TLS access
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.obsidian_alb_logs_bucket01[0].arn,
          "${aws_s3_bucket.obsidian_alb_logs_bucket01[0].arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },

      # Allow ALB log delivery
      {
        Sid    = "AllowALBLogDelivery"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_elb_service_account.this.arn
        }
        Action = [
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.obsidian_alb_logs_bucket01[0].arn}/${var.alb_access_logs_prefix}/AWSLogs/${data.aws_caller_identity.obsidian_self01.account_id}/*"
      },
      {
        Sid    = "AllowALBLogDeliveryAclCheck"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_elb_service_account.this.arn
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.obsidian_alb_logs_bucket01[0].arn
      }

    ]
  })
}

############################################
# Reminder: Patch the ALB resource
############################################

# Students must add this inside:
# resource "aws_lb" "obsidian_alb01" { ... } in bonus_b.tf
#
# Explanation: Obsidian keeps flight logs—ALB access logs go to S3 for audits and incident response.
#
# access_logs {
#   bucket  = aws_s3_bucket.obsidian_alb_logs_bucket01[0].bucket
#   prefix  = var.alb_access_logs_prefix
#   enabled = var.enable_alb_access_logs
# }
