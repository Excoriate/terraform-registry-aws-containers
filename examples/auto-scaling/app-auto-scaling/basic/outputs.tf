output "aws_region_for_deploy" {
  value       = module.main_module.aws_region_for_deploy
  description = "The AWS region where the module is deployed."
}

output "app_autoscaling_ecs_id" {
  value       = module.main_module.app_autoscaling_ecs_id
  description = "The ID of the application autoscaling target for ECS."
}

output "app_autoscaling_ecs_role_arn" {
  value       = module.main_module.app_autoscaling_ecs_role_arn
  description = "The ARN of the application autoscaling target for ECS."
}

output "app_autoscaling_ecs_min_capacity" {
  value       = module.main_module.app_autoscaling_ecs_min_capacity
  description = "The minimum capacity of the application autoscaling target for ECS."
}

output "app_autoscaling_ecs_max_capacity" {
  value       = module.main_module.app_autoscaling_ecs_max_capacity
  description = "The maximum capacity of the application autoscaling target for ECS."
}

output "app_autoscaling_ecs_resource_id" {
  value       = module.main_module.app_autoscaling_ecs_resource_id
  description = "The resource ID of the application autoscaling target for ECS."
}
