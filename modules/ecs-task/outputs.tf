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
  value       = [for t in aws_ecs_task_definition.this : t.arn]
  description = "The ARN of the task definition."
}

output "ecs_task_definition_family" {
  value       = [for t in aws_ecs_task_definition.this : t.family]
  description = "The family of the task definition."
}

output "ecs_task_definition_revision" {
  value       = [for t in aws_ecs_task_definition.this : t.revision]
  description = "The revision of the task definition."
}

output "ecs_task_definition_task_role_arn" {
  value       = [for t in aws_ecs_task_definition.this : t.task_role_arn]
  description = "The ARN of the IAM role that grants containers in the task permission to call AWS APIs on your behalf."
}

output "ecs_task_definition_execution_role_arn" {
  value       = [for t in aws_ecs_task_definition.this : t.execution_role_arn]
  description = "The ARN of the IAM role that grants the Amazon ECS container agent permission to make AWS API calls on your behalf."
}

output "ecs_task_definition_network_mode" {
  value       = [for t in aws_ecs_task_definition.this : t.network_mode]
  description = "The network mode of the task definition."
}

output "ecs_task_definition_container_definitions" {
  value       = [for t in aws_ecs_task_definition.this : t.container_definitions]
  description = "The container definitions of the task definition."
}

output "ecs_task_definition_cpu" {
  value       = [for t in aws_ecs_task_definition.this : t.cpu]
  description = "The number of CPU units used by the task."
}

output "ecs_task_definition_memory" {
  value       = [for t in aws_ecs_task_definition.this : t.memory]
  description = "The amount (in MiB) of memory used by the task."
}

output "ecs_task_definition_proxy_configuration" {
  value       = [for t in aws_ecs_task_definition.this : t.proxy_configuration]
  description = "The proxy configuration of the task definition."
}

// FIXME: Fix this functionality later.
output "is_extra_iam_policies_passed" {
  value       = local.extra_iam_policies
  description = "Whether the extra IAM policies are passed or not."
}
