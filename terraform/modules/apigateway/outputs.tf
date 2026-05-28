output "api_id" {
  value = module.http_api.api_id
}

output "api_endpoint" {
  value = module.http_api.api_endpoint
}

output "api_execution_arn" {
  value = module.http_api.api_execution_arn
}

output "stage_id" {
  value = module.http_api.stage_id
}

output "stage_name" {
  value = "$default"
}