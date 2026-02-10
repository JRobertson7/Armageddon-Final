provider "aws" {
  region = var.aws_region
}

# CloudFront viewer cert + CLOUDFRONT WAF must be managed in us-east-1
provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}
