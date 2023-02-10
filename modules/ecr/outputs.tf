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
output "ecr_repository_url" {
  value       = [for repo in aws_ecr_repository.this : repo.repository_url]
  description = "The URL of the ECR repository."
}

output "ecr_repository_arn" {
  value       = [for repo in aws_ecr_repository.this : repo.arn]
  description = "The ARN of the ECR repository."
}

output "ecr_repository_name" {
  value       = [for repo in aws_ecr_repository.this : repo.name]
  description = "The name of the ECR repository."
}

output "ecr_repository_registry_id" {
  value       = [for repo in aws_ecr_repository.this : repo.registry_id]
  description = "The registry ID where the repository was created."
}
