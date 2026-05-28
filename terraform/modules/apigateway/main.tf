module "api_gateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "6.1.0"

  name          = "${var.project_name}-${var.environment}-${var.name}"
  description   = "Infrastructure API Gateway - VPC and Network management"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["Content-Type", "Authorization"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_origins = ["*"]
    max_age       = 300
  }

  authorizers = {
    cognito = {
      authorizer_type  = "JWT"
      name             = "${var.project_name}-cognito-auth-${var.environment}"
      identity_sources = ["$request.header.Authorization"]
      jwt_configuration = {
        audience = [var.cognito_user_pool_client_id]
        issuer   = "https://cognito-idp.${var.region}.amazonaws.com/${var.cognito_user_pool_id}"
      }
    }
  }

  stage_name = "$default"
  routes     = var.routes

  stage_access_log_settings = {
    create_log_group            = true
    log_group_name              = "/aws/apigateway/${var.project_name}-${var.environment}"
    log_group_retention_in_days = var.log_retention_days
    format = jsonencode({
      requestId      = "$context.requestId"
      sourceIp       = "$context.identity.sourceIp"
      httpMethod     = "$context.httpMethod"
      path           = "$context.path"
      status         = "$context.status"
      responseLength = "$context.responseLength"
      requestTime    = "$context.requestTime"
      errorMessage   = "$context.error.message"
    })
  }

  tags = var.tags
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.api_gateway.api_execution_arn}/*/*"
}
