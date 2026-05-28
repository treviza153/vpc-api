module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "8.8.0"

  function_name = "${var.project_name}-${var.environment}"
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout

  source_path = var.lambda_source_path

  create_role = false
  lambda_role = var.lambda_role_arn

  environment_variables = var.environment_variables

  cloudwatch_logs_retention_in_days = var.log_retention_days
  tags                              = var.tags
}
