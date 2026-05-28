variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  description = "AWS region where the API Gateway will be deployed"
  type        = string
}

variable "lambda_function_name" {
  type = string
}

variable "log_retention_days" {
  type    = number
  default = 14
}

variable "cognito_user_pool_id" {
  description = "Cognito User Pool ID used to build the JWT issuer URL"
  type        = string
}

variable "cognito_user_pool_client_id" {
  description = "Cognito App Client ID used as the JWT audience"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "name" {
  type = string
}

variable "routes" {
  description = "Map of API Gateway routes and their configurations (authorizers, etc.)"
  type        = map(any)
  default     = {}
}
