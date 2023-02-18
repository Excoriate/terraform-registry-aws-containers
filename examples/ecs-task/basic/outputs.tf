output "is_enabled" {
  value       = var.is_enabled
  description = "Whether the module is enabled or not."
}

output "aws_region_for_deploy_this" {
  value       = module.main_module.aws_region_for_deploy_this
  description = "The AWS region where the module is deployed."
}


/*
-------------------------------------
Custom outputs
-------------------------------------
*/
output "ecs_task_definition_arn" {
  value       = module.main_module.ecs_task_definition_arn
  description = "The ARN of the task definition."
}

output "ecs_task_definition_family" {
  value       = module.main_module.ecs_task_definition_family
  description = "The family of the task definition."
}

output "ecs_task_definition_revision" {
  value       = module.main_module.ecs_task_definition_revision
  description = "The revision of the task definition."
}

output "ecs_task_definition_task_role_arn" {
  value       = module.main_module.ecs_task_definition_task_role_arn
  description = "The ARN of the IAM role that grants containers in the task permission to call AWS APIs on your behalf."
}

output "ecs_task_definition_execution_role_arn" {
  value       = module.main_module.ecs_task_definition_execution_role_arn
  description = "The ARN of the IAM role that grants the Amazon ECS container agent permission to make AWS API calls on your behalf."
}

output "ecs_task_definition_network_mode" {
  value       = module.main_module.ecs_task_definition_network_mode
  description = "The network mode of the task definition."
}

output "ecs_task_definition_container_definitions" {
  value       = module.main_module.ecs_task_definition_container_definitions
  description = "The container definitions of the task definition."
}

output "ecs_task_definition_cpu" {
  value       = module.main_module.ecs_task_definition_cpu
  description = "The number of CPU units used by the task."
}

output "ecs_task_definition_memory" {
  value       = module.main_module.ecs_task_definition_memory
  description = "The amount (in MiB) of memory used by the task."
}

output "ecs_task_definition_proxy_configuration" {
  value       = module.main_module.ecs_task_definition_proxy_configuration
  description = "The proxy configuration of the task definition."
}


