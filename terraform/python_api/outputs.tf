output "api_gateway_default_url" {
  description = "Default API Gateway invoke URL (pre-custom domain)"
  value       = module.apigateway.api_endpoint
}

output "custom_domain_url" {
  description = "Public URL of the API via the custom domain"
  value       = module.route53.custom_domain_url
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = module.lambda.lambda_function_name
}

output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = module.lambda.lambda_function_arn
}

output "vpc_dynamodb_table_name" {
  description = "DynamoDB table that stores VPC records"
  value       = module.dynamodb.vpc_table_name
}

output "network_dynamodb_table_name" {
  description = "DynamoDB table that stores network records"
  value       = module.dynamodb.network_table_name
}

output "api_gateway_id" {
  description = "API Gateway ID"
  value       = module.apigateway.api_id
}

# ─── Cognito ─────────────────────────────────────────────────────────────────────────────

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.cognito.user_pool_id
}

output "cognito_user_pool_client_id" {
  description = "Cognito App Client ID (needed to authenticate and obtain JWT tokens)"
  value       = module.cognito.user_pool_client_id
}

output "cognito_user_pool_endpoint" {
  description = "Cognito User Pool endpoint"
  value       = module.cognito.user_pool_endpoint
}
