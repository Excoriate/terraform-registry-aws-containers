output "ecr_repository_url" {
  value       = module.main_module.ecr_repository_url
  description = "The URL of the ECR repository."
}

output "ecr_repository_arn" {
  value       = module.main_module.ecr_repository_arn
  description = "The ARN of the ECR repository."
}

output "ecr_repository_name" {
  value       = module.main_module.ecr_repository_name
  description = "The name of the ECR repository."
}

output "ecr_repository_registry_id" {
  value       = module.main_module.ecr_repository_registry_id
  description = "The registry ID where the repository was created."
}
