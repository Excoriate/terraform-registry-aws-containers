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
  value       = [for svc in aws_ecs_service.this : svc.name]
  description = "The name of the ECS service."
}

output "ecs_service_id" {
  value       = [for svc in aws_ecs_service.this : svc.id]
  description = "The ARN of the ECS service."
}

output "ecs_service_cluster" {
  value       = [for svc in aws_ecs_service.this : svc.cluster]
  description = "The ARN of the ECS service."
}

output "ecs_service_task_definition" {
  value       = [for svc in aws_ecs_service.this : svc.task_definition]
  description = "The ARN of the ECS service."
}

output "ecs_service_launch_type" {
  value       = [for svc in aws_ecs_service.this : svc.launch_type]
  description = "The launch type on which to run your service."
}

output "ecs_service_desired_count" {
  value       = [for svc in aws_ecs_service.this : svc.desired_count]
  description = "The number of instances of the task definition to place and keep running."
}

output "ecs_service_deployment_maximum_percent" {
  value       = [for svc in aws_ecs_service.this : svc.deployment_maximum_percent]
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment."
}

output "ecs_service_deployment_minimum_healthy_percent" {
  value       = [for svc in aws_ecs_service.this : svc.deployment_minimum_healthy_percent]
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
}

output "ecs_service_health_check_grace_period_seconds" {
  value       = [for svc in aws_ecs_service.this : svc.health_check_grace_period_seconds]
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647."
}

output "ecs_service_scheduling_strategy" {
  value       = [for svc in aws_ecs_service.this : svc.scheduling_strategy]
  description = "The scheduling strategy to use for the service."
}
