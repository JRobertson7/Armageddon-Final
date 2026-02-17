variable "manage_route53_in_terraform" {
  description = "If true, create/manage Route53 hosted zone + records in Terraform."
  type        = bool
  default     = true
}

variable "route53_hosted_zone_id" {
  description = "If manage_route53_in_terraform=false, provide existing Hosted Zone ID for domain."
  type        = string
  default     = "Z0485629HS0A5L9EBNRR"
}

variable "acm_cert_arn" {
  description = "Existing ACM certificate ARN for the app domain"
  type        = string
}
