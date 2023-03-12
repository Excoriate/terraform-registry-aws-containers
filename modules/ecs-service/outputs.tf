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
output "ecs_service_name" {
  value       = length([for svc in aws_ecs_service.this : svc.name]) > 0 ? [for svc in aws_ecs_service.this : svc.name] : length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.name]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.name] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.name]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.name] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.name]
  description = "The name of the ECS service."
}

output "ecs_service_id" {
  value       = length([for svc in aws_ecs_service.this : svc.id]) > 0 ? [for svc in aws_ecs_service.this : svc.id] : length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.id]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.id] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.id]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.id] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.id]
  description = "The ARN of the ECS service."
}

output "ecs_service_cluster" {
  value       = length([for svc in aws_ecs_service.this : svc.cluster]) > 0 ? [for svc in aws_ecs_service.this : svc.cluster] : length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.cluster]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.cluster] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.cluster]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.cluster] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.cluster]
  description = "The ARN of the ECS service."
}

output "ecs_service_task_definition" {
  value       = length([for svc in aws_ecs_service.this : svc.task_definition]) > 0 ? [for svc in aws_ecs_service.this : svc.task_definition] : length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.task_definition]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.task_definition] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.task_definition]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.task_definition] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.task_definition]
  description = "The ARN of the ECS service."
}

output "ecs_service_launch_type" {
  value       = length([for svc in aws_ecs_service.this : svc.launch_type]) > 0 ? [for svc in aws_ecs_service.this : svc.launch_type] : length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.launch_type]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.launch_type] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.launch_type]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.launch_type] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.launch_type]
  description = "The launch type on which to run your service."
}

output "ecs_service_desired_count" {
  value       = length([for svc in aws_ecs_service.this : svc.desired_count]) > 0 ? [for svc in aws_ecs_service.this : svc.desired_count] : length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.desired_count]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.desired_count] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.desired_count]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.desired_count] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.desired_count]
  description = "The number of instances of the task definition to place and keep running."
}

output "ecs_service_deployment_maximum_percent" {
  value       = length([for svc in aws_ecs_service.this : svc.deployment_maximum_percent]) > 0 ? [for svc in aws_ecs_service.this : svc.deployment_maximum_percent] : length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.deployment_maximum_percent]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.deployment_maximum_percent] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.deployment_maximum_percent]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.deployment_maximum_percent] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.deployment_maximum_percent]
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment."
}

output "ecs_service_deployment_minimum_healthy_percent" {
  value       = length([for svc in aws_ecs_service.this : svc.deployment_minimum_healthy_percent]) > 0 ? [for svc in aws_ecs_service.this : svc.deployment_minimum_healthy_percent] : length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.deployment_minimum_healthy_percent]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.deployment_minimum_healthy_percent] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.deployment_minimum_healthy_percent]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.deployment_minimum_healthy_percent] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.deployment_minimum_healthy_percent]
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
}

output "ecs_service_health_check_grace_period_seconds" {
  value       = length([for svc in aws_ecs_service.this : svc.health_check_grace_period_seconds]) > 0 ? [for svc in aws_ecs_service.this : svc.health_check_grace_period_seconds] : length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.health_check_grace_period_seconds]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.health_check_grace_period_seconds] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.health_check_grace_period_seconds]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.health_check_grace_period_seconds] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.health_check_grace_period_seconds]
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647."
}

output "ecs_service_scheduling_strategy" {
  value       = length([for svc in aws_ecs_service.this : svc.scheduling_strategy]) > 0 ? [for svc in aws_ecs_service.this : svc.scheduling_strategy] : length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.scheduling_strategy]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.scheduling_strategy] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.scheduling_strategy]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.scheduling_strategy] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.scheduling_strategy]
  description = "The scheduling strategy to use for the service."
}
