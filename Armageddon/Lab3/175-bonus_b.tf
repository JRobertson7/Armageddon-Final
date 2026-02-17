############################################
# Bonus B - ALB (Public) -> Target Group (Private EC2) + TLS + WAF + Monitoring
############################################

locals {
  # Explanation: This is the roar address — where the galaxy finds your app.
  obsidian_fqdn = "${var.app_subdomain}.${var.domain_name}"
}

############################################
# Security Group: ALB
############################################

# Explanation: The ALB SG is the blast shield — only allow what the Rebellion needs (80/443).
resource "aws_security_group" "obsidian_alb_sg01" {
  name        = "${var.project_name}-alb-sg01"
  description = "ALB security group"
  vpc_id      = aws_vpc.obsidian_vpc01.id

  ingress {
    description = "Allow HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ✅ FIX: allow ALB to talk to EC2 SG directly
  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.obsidian_ec2_sg01.id]
  }

  tags = {
    Name = "${var.project_name}-alb-sg01"
  }
}

# Explanation: Obsidian only opens the hangar door — allow ALB -> EC2 on app port (80).
resource "aws_security_group_rule" "obsidian_ec2_ingress_from_alb01" {
  type                     = "ingress"
  security_group_id        = aws_security_group.obsidian_ec2_sg01.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.obsidian_alb_sg01.id
}

############################################
# Application Load Balancer
############################################

# Explanation: The ALB is your public customs checkpoint — it speaks TLS and forwards to private targets.
resource "aws_lb" "obsidian_alb01" {
  name               = "${var.project_name}-alb01"
  load_balancer_type = "application"
  internal           = false

  security_groups = [aws_security_group.obsidian_alb_sg01.id]
  subnets         = aws_subnet.obsidian_public_subnets[*].id

  # Explanation: Obsidian keeps flight logs—ALB access logs go to S3 for audits and incident response.
  access_logs {
    bucket  = aws_s3_bucket.obsidian_alb_logs_bucket01[0].bucket
    prefix  = var.alb_access_logs_prefix
    enabled = var.enable_alb_access_logs
  }

  tags = {
    Name = "${var.project_name}-alb01"
  }
}

############################################
# Target Group + Attachment
############################################

# Explanation: Target groups are Obsidian’s “who do I forward to?” list — private EC2 lives here.
resource "aws_lb_target_group" "obsidian_tg01" {
  name     = "${var.project_name}-tg01"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.obsidian_vpc01.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.project_name}-tg01"
  }
}

# Explanation: Obsidian personally introduces the ALB to the private EC2.
resource "aws_lb_target_group_attachment" "obsidian_tg_attach01" {
  target_group_arn = aws_lb_target_group.obsidian_tg01.arn
  target_id        = aws_instance.obsidian_ec201.id
  port             = 80
}

############################################
# ACM Certificate (TLS) - reference existing
############################################

# Explanation: Use the existing ACM certificate for obsidiandevsecops.com
data "aws_acm_certificate" "obsidian_existing_cert" {
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

############################################
# ALB Listeners
############################################

# Explanation: HTTP listener redirects everyone to HTTPS.
resource "aws_lb_listener" "obsidian_http_listener01" {
  load_balancer_arn = aws_lb.obsidian_alb01.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Explanation: HTTPS listener terminates TLS and forwards to targets.
resource "aws_lb_listener" "obsidian_https_listener01" {
  load_balancer_arn = aws_lb.obsidian_alb01.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.obsidian_existing_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.obsidian_tg01.arn
  }

  # ✅ Remove depends_on — no DNS validation needed
}

############################################
# WAFv2 Web ACL
############################################

# Explanation: WAF is the shield generator.
resource "aws_wafv2_web_acl" "obsidian_waf01" {
  count = var.enable_waf ? 1 : 0

  name  = "${var.project_name}-waf01"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-waf01"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-waf-common"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    Name = "${var.project_name}-waf01"
  }
}

resource "aws_wafv2_web_acl_association" "obsidian_waf_assoc01" {
  count = var.enable_waf ? 1 : 0

  resource_arn = aws_lb.obsidian_alb01.arn
  web_acl_arn  = aws_wafv2_web_acl.obsidian_waf01[0].arn
}

############################################
# CloudWatch Alarm
############################################

# Explanation: When the ALB starts throwing 5xx — page the on-call.
resource "aws_cloudwatch_metric_alarm" "obsidian_alb_5xx_alarm01" {
  alarm_name          = "${var.project_name}-alb-5xx-alarm01"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alb_5xx_evaluation_periods
  threshold           = var.alb_5xx_threshold
  period              = var.alb_5xx_period_seconds
  statistic           = "Sum"

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_ELB_5XX_Count"

  dimensions = {
    LoadBalancer = aws_lb.obsidian_alb01.arn_suffix
  }

  alarm_actions = [aws_sns_topic.obsidian_sns_topic01.arn]

  tags = {
    Name = "${var.project_name}-alb-5xx-alarm01"
  }
}

############################################
# CloudWatch Dashboard
############################################

# Explanation: Dashboards are your cockpit HUD.
resource "aws_cloudwatch_dashboard" "obsidian_dashboard01" {
  dashboard_name = "${var.project_name}-dashboard01"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.obsidian_alb01.arn_suffix],
            [".", "HTTPCode_ELB_5XX_Count", ".", aws_lb.obsidian_alb01.arn_suffix]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "Obsidian ALB: Requests + 5XX"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.obsidian_alb01.arn_suffix]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Obsidian ALB: Target Response Time"
        }
      }
    ]
  })
}
