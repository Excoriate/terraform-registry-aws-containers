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
output "cluster_id" {
  value       = [for cluster in aws_ecs_cluster.this : cluster.id]
  description = "The ID of the ECS cluster."
}

output "cluster_arn" {
  value       = [for cluster in aws_ecs_cluster.this : cluster.arn]
  description = "The ARN of the ECS cluster."
}

output "cluster_name" {
  value       = [for cluster in aws_ecs_cluster.this : cluster.name]
  description = "The name of the ECS cluster."
}

output "cluster_capacity_providers" {
  value       = [for cluster in aws_ecs_cluster.this : cluster.capacity_providers]
  description = "The capacity providers of the ECS cluster."
}

output "cluster_default_capacity_provider_strategy" {
  value       = [for cluster in aws_ecs_cluster.this : cluster.default_capacity_provider_strategy]
  description = "The default capacity provider strategy of the ECS cluster."
}
