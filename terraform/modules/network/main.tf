data "aws_route53_zone" "main" {
  name         = var.hosted_zone_name
  private_zone = false
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "6.3.0"

  domain_name         = var.domain_name
  zone_id             = data.aws_route53_zone.main.zone_id
  validation_method   = "DNS"
  wait_for_validation = true

  tags = var.tags
}

resource "aws_domain_name" "api" {
  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = module.acm.acm_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_api_mapping" "api" {
  api_id      = var.api_id
  domain_name = aws_domain_name.api.id
  stage       = var.stage_name
}

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_domain_name.api.domain_name_configuration[0].target_domain_name
    zone_id                = aws_domain_name.api.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
