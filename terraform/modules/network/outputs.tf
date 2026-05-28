output "custom_domain_url" {
  value = "https://${var.domain_name}"
}

output "certificate_arn" {
  value = module.acm.acm_certificate_arn
}

output "domain_name_target" {
  value = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].target_domain_name
}
