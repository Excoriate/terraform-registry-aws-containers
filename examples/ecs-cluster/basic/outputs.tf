output "cluster_id" {
  value       = module.main_module.cluster_id
  description = "The ID of the ECS cluster."
}

output "cluster_arn" {
  value       = module.main_module.cluster_arn
  description = "The ARN of the ECS cluster."
}

output "cluster_name" {
  value       = module.main_module.cluster_name
  description = "The name of the ECS cluster."
}

output "cluster_capacity_providers" {
  value       = module.main_module.cluster_capacity_providers
  description = "The capacity providers of the ECS cluster."
}

output "cluster_default_capacity_provider_strategy" {
  value       = module.main_module.cluster_default_capacity_provider_strategy
  description = "The default capacity provider strategy of the ECS cluster."
}
