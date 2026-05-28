variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used as a prefix for all resource names"
  type        = string
  default     = "infra-api"
}

variable "gateway_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "api"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "domain_name" {
  description = "Custom domain name for the API (e.g., api.example.com)"
  type        = string
}

variable "hosted_zone_name" {
  description = "Existing Route53 hosted zone name (e.g., example.com)"
  type        = string
}

variable "lambda_handler" {
  description = "Lambda handler entrypoint"
  type        = string
  default     = "lambda_handler.lambda_handler"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.12"
}

variable "lambda_memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 256
}

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention period in days"
  type        = number
  default     = 14
}

variable "dynamodb_deletion_protection_enabled" {
  description = "Enable deletion protection on DynamoDB tables"
  type        = bool
  default     = false
}

variable "cognito_access_token_validity_hours" {
  description = "How long (in hours) the access token is valid (1–24)"
  type        = number
  default     = 1
}

variable "cognito_id_token_validity_hours" {
  description = "How long (in hours) the ID token is valid (1–24)"
  type        = number
  default     = 1
}

variable "cognito_refresh_token_validity_days" {
  description = "How long (in days) the refresh token is valid (1–3650)"
  type        = number
  default     = 30
}
