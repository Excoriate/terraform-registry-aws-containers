output "is_enabled" {
  value       = var.is_enabled
  description = "Whether the module is enabled or not."
}

output "aws_region_for_deploy_this" {
  value       = local.aws_region_to_deploy
  description = "The AWS region where the module is deployed."
}

output "tags_set" {
  value       = var.tags
  description = "The tags set for the module."
}

/*
-------------------------------------
Custom outputs
-------------------------------------
*/
output "ecs_task_definition_arn" {
  value       = length([for t in aws_ecs_task_definition.default : t]) > 0 ? [for t in aws_ecs_task_definition.default : t.arn] : length([for t in aws_ecs_task_definition.default_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.default_built_in_permissions : t.arn] : length([for t in aws_ecs_task_definition.tg_unmanaged_default : t]) > 0 ? [for t in aws_ecs_task_definition.tg_unmanaged_default : t.arn] : length([for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t.arn] : []
  description = "The ARN of the task definition."
}

output "ecs_task_definition_family" {
  value       = length([for t in aws_ecs_task_definition.default : t]) > 0 ? [for t in aws_ecs_task_definition.default : t.family] : length([for t in aws_ecs_task_definition.default_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.default_built_in_permissions : t.family] : length([for t in aws_ecs_task_definition.tg_unmanaged_default : t]) > 0 ? [for t in aws_ecs_task_definition.tg_unmanaged_default : t.family] : length([for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t.family] : []
  description = "The family of the task definition."
}

output "ecs_task_definition_revision" {
  value       = length([for t in aws_ecs_task_definition.default : t]) > 0 ? [for t in aws_ecs_task_definition.default : t.revision] : length([for t in aws_ecs_task_definition.default_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.default_built_in_permissions : t.revision] : length([for t in aws_ecs_task_definition.tg_unmanaged_default : t]) > 0 ? [for t in aws_ecs_task_definition.tg_unmanaged_default : t.revision] : length([for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t.revision] : []
  description = "The revision of the task definition."
}

output "ecs_task_definition_task_role_arn" {
  value       = length([for t in aws_ecs_task_definition.default : t]) > 0 ? [for t in aws_ecs_task_definition.default : t.task_role_arn] : length([for t in aws_ecs_task_definition.default_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.default_built_in_permissions : t.task_role_arn] : length([for t in aws_ecs_task_definition.tg_unmanaged_default : t]) > 0 ? [for t in aws_ecs_task_definition.tg_unmanaged_default : t.task_role_arn] : length([for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t.task_role_arn] : []
  description = "The ARN of the IAM role that grants containers in the task permission to call AWS APIs on your behalf."
}

output "ecs_task_definition_execution_role_arn" {
  value       = length([for t in aws_ecs_task_definition.default : t]) > 0 ? [for t in aws_ecs_task_definition.default : t.execution_role_arn] : length([for t in aws_ecs_task_definition.default_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.default_built_in_permissions : t.execution_role_arn] : length([for t in aws_ecs_task_definition.tg_unmanaged_default : t]) > 0 ? [for t in aws_ecs_task_definition.tg_unmanaged_default : t.execution_role_arn] : length([for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t.execution_role_arn] : []
  description = "The ARN of the IAM role that grants the Amazon ECS container agent permission to make AWS API calls on your behalf."
}

output "ecs_task_definition_network_mode" {
  value       = length([for t in aws_ecs_task_definition.default : t]) > 0 ? [for t in aws_ecs_task_definition.default : t.network_mode] : length([for t in aws_ecs_task_definition.default_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.default_built_in_permissions : t.network_mode] : length([for t in aws_ecs_task_definition.tg_unmanaged_default : t]) > 0 ? [for t in aws_ecs_task_definition.tg_unmanaged_default : t.network_mode] : length([for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t.network_mode] : []
  description = "The network mode of the task definition."
}

output "ecs_task_definition_container_definitions" {
  value       = length([for t in aws_ecs_task_definition.default : t]) > 0 ? [for t in aws_ecs_task_definition.default : t.container_definitions] : length([for t in aws_ecs_task_definition.default_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.default_built_in_permissions : t.container_definitions] : length([for t in aws_ecs_task_definition.tg_unmanaged_default : t]) > 0 ? [for t in aws_ecs_task_definition.tg_unmanaged_default : t.container_definitions] : length([for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t.container_definitions] : []
  description = "The container definitions of the task definition."
}

output "ecs_task_definition_cpu" {
  value       = length([for t in aws_ecs_task_definition.default : t]) > 0 ? [for t in aws_ecs_task_definition.default : t.cpu] : length([for t in aws_ecs_task_definition.default_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.default_built_in_permissions : t.cpu] : length([for t in aws_ecs_task_definition.tg_unmanaged_default : t]) > 0 ? [for t in aws_ecs_task_definition.tg_unmanaged_default : t.cpu] : length([for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t.cpu] : []
  description = "The number of CPU units used by the task."
}

output "ecs_task_definition_memory" {
  value       = length([for t in aws_ecs_task_definition.default : t]) > 0 ? [for t in aws_ecs_task_definition.default : t.memory] : length([for t in aws_ecs_task_definition.default_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.default_built_in_permissions : t.memory] : length([for t in aws_ecs_task_definition.tg_unmanaged_default : t]) > 0 ? [for t in aws_ecs_task_definition.tg_unmanaged_default : t.memory] : length([for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t.memory] : []
  description = "The amount (in MiB) of memory used by the task."
}

output "ecs_task_definition_proxy_configuration" {
  value       = length([for t in aws_ecs_task_definition.default : t]) > 0 ? [for t in aws_ecs_task_definition.default : t.proxy_configuration] : length([for t in aws_ecs_task_definition.default_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.default_built_in_permissions : t.proxy_configuration] : length([for t in aws_ecs_task_definition.tg_unmanaged_default : t]) > 0 ? [for t in aws_ecs_task_definition.tg_unmanaged_default : t.proxy_configuration] : length([for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t]) > 0 ? [for t in aws_ecs_task_definition.tf_unmanaged_built_in_permissions : t.proxy_configuration] : []
  description = "The proxy configuration of the task definition."
}
