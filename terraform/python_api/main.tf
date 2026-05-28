locals {
  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "dynamodb_vpcs_table" {
  source = "../modules/dynamodb"

  project_name                = var.project_name
  table_name                  = "${var.gateway_name}-vpcs"
  environment                 = var.environment
  deletion_protection_enabled = var.dynamodb_deletion_protection_enabled
  tags                        = local.tags
}

module "dynamodb_network_table" {
  source = "../modules/dynamodb"

  project_name                = var.project_name
  table_name                  = "${var.gateway_name}-networks"
  environment                 = var.environment
  deletion_protection_enabled = var.dynamodb_deletion_protection_enabled
  tags                        = local.tags
}

module "iam" {
  source = "../modules/iam"

  project_name    = var.project_name
  environment     = var.environment
  name            = "${var.project_name}-vpc-api-lambda"
  policy_document = data.aws_iam_policy_document.lambda_permissions.json
  tags            = local.tags
}

module "lambda" {
  source = "../modules/lambda"

  project_name       = var.project_name
  environment        = var.environment
  lambda_role_arn    = module.iam.lambda_role_arn
  lambda_source_path = abspath("${path.root}/../../api")
  lambda_handler     = var.lambda_handler
  lambda_runtime     = var.lambda_runtime
  lambda_memory_size = var.lambda_memory_size
  lambda_timeout     = var.lambda_timeout
  log_retention_days = var.log_retention_days
  environment_variables = {
    VPC_TABLE     = module.dynamodb.vpc_table_name
    NETWORK_TABLE = module.dynamodb.network_table_name
    ENVIRONMENT   = var.environment
  }
  tags = local.tags
}

module "cognito" {
  source = "../modules/cognito"

  project_name                = var.project_name
  environment                 = var.environment
  access_token_validity_hours = var.cognito_access_token_validity_hours
  id_token_validity_hours     = var.cognito_id_token_validity_hours
  refresh_token_validity_days = var.cognito_refresh_token_validity_days
  tags                        = local.tags
}

module "apigateway" {
  source = "../modules/apigateway"

  project_name                = var.project_name
  environment                 = var.environment
  region                      = var.aws_region
  name                        = var.gateway_name
  lambda_function_name        = module.lambda.lambda_function_name
  cognito_user_pool_id        = module.cognito.user_pool_id
  cognito_user_pool_client_id = module.cognito.user_pool_client_id
  log_retention_days          = var.log_retention_days
  tags                        = local.tags

  routes = {
    "POST /vpc" = {
      authorizer_key     = "cognito"
      authorization_type = "JWT"
      integration = {
        uri                    = module.lambda.lambda_function_invoke_arn
        payload_format_version = "2.0"
      }
    }
    "GET /vpc" = {
      authorizer_key     = "cognito"
      authorization_type = "JWT"
      integration = {
        uri                    = module.lambda.lambda_function_invoke_arn
        payload_format_version = "2.0"
      }
    }
    "POST /network" = {
      authorizer_key     = "cognito"
      authorization_type = "JWT"
      integration = {
        uri                    = module.lambda.lambda_function_invoke_arn
        payload_format_version = "2.0"
      }
    }
    "GET /network" = {
      authorizer_key     = "cognito"
      authorization_type = "JWT"
      integration = {
        uri                    = module.lambda.lambda_function_invoke_arn
        payload_format_version = "2.0"
      }
    }
  }
}

module "dns" {
  source = "../modules/network"

  hosted_zone_name = var.hosted_zone_name
  domain_name      = var.domain_name
  api_id           = module.apigateway.api_id
  stage_name       = module.apigateway.stage_name
  tags             = local.tags
}
