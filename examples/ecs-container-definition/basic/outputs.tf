output "json_map_encoded_list" {
  description = "JSON string encoded list of container definitions for use with other terraform resources such as aws_ecs_task_definition"
  value       = module.main_module.json_map_encoded_list
}

output "json_map_encoded" {
  description = "JSON string encoded container definitions for use with other terraform resources such as aws_ecs_task_definition"
  value       = module.main_module.json_map_encoded
}

output "json_map_object" {
  description = "JSON map encoded container definition"
  value       = module.main_module.json_map_object
}

output "sensitive_json_map_encoded_list" {
  description = "JSON string encoded list of container definitions for use with other terraform resources such as aws_ecs_task_definition (sensitive)"
  value       = module.main_module.json_map_encoded_list
  sensitive   = true
}

output "sensitive_json_map_encoded" {
  description = "JSON string encoded container definitions for use with other terraform resources such as aws_ecs_task_definition (sensitive)"
  value       = module.main_module.json_map_encoded
  sensitive   = true
}

output "sensitive_json_map_object" {
  description = "JSON map encoded container definition (sensitive)"
  value       = module.main_module.json_map_object
  sensitive   = true
}
