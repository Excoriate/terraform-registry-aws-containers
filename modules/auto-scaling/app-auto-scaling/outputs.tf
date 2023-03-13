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
output "aws_region_for_deploy" {
  value       = local.aws_region_to_deploy
  description = "The AWS region where the module is deployed."
}

output "app_autoscaling_ecs_id" {
  value       = [for ac in aws_appautoscaling_target.this : ac.id]
  description = "The ID of the application autoscaling target for ECS."
}

output "app_autoscaling_ecs_role_arn" {
  value       = [for ac in aws_appautoscaling_target.this : ac.role_arn]
  description = "The ARN of the application autoscaling target for ECS."
}

output "app_autoscaling_ecs_min_capacity" {
  value       = [for ac in aws_appautoscaling_target.this : ac.min_capacity]
  description = "The minimum capacity of the application autoscaling target for ECS."
}

output "app_autoscaling_ecs_max_capacity" {
  value       = [for ac in aws_appautoscaling_target.this : ac.max_capacity]
  description = "The maximum capacity of the application autoscaling target for ECS."
}

output "app_autoscaling_ecs_resource_id" {
  value       = [for ac in aws_appautoscaling_target.this : ac.resource_id]
  description = "The resource ID of the application autoscaling target for ECS."
}
