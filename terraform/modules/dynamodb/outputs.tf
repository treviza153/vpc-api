output "vpc_table_name" {
  value = module.vpcs_table.dynamodb_table_id
}

output "vpc_table_arn" {
  value = module.vpcs_table.dynamodb_table_arn
}

output "network_table_name" {
  value = module.networks_table.dynamodb_table_id
}

output "network_table_arn" {
  value = module.networks_table.dynamodb_table_arn
}