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
output "execution_role_ooo_id" {
  value       = [for role in aws_iam_role.execution_role_ooo : role.id]
  description = "The ID of the OOO execution role (common)."
}

output "execution_role_ooo_arn" {
  value       = [for role in aws_iam_role.execution_role_ooo : role.arn]
  description = "The ARN of the OOO execution role (common)."
}

output "execution_role_ooo_name" {
  value       = [for role in aws_iam_role.execution_role_ooo : role.name]
  description = "The name of the OOO execution role (common)."
}

output "execution_role_ooo_unique_id" {
  value       = [for role in aws_iam_role.execution_role_ooo : role.unique_id]
  description = "The unique ID of the OOO execution role (common)."
}

output "execution_role_ooo_assume_policy_doc" {
  value       = [for role in aws_iam_role.execution_role_ooo : role.assume_role_policy]
  description = "The IAM policy document of the OOO execution role (common)."
}

output "execution_role_custom_id" {
  value       = [for role in aws_iam_role.execution_role_custom : role.id]
  description = "The ID of the custom execution role."
}

output "execution_role_custom_arn" {
  value       = [for role in aws_iam_role.execution_role_custom : role.arn]
  description = "The ARN of the custom execution role."
}

output "execution_role_custom_name" {
  value       = [for role in aws_iam_role.execution_role_custom : role.name]
  description = "The name of the custom execution role."
}

output "execution_role_custom_unique_id" {
  value       = [for role in aws_iam_role.execution_role_custom : role.unique_id]
  description = "The unique ID of the custom execution role."
}

output "execution_role_custom_assume_policy_doc" {
  value       = [for role in aws_iam_role.execution_role_custom : role.assume_role_policy]
  description = "The IAM policy document of the custom execution role."
}

output "task_role_ooo_id" {
  value       = [for role in aws_iam_role.task_role_ooo : role.id]
  description = "The ID of the OOO task role (common)."
}

output "task_role_ooo_arn" {
  value       = [for role in aws_iam_role.task_role_ooo : role.arn]
  description = "The ARN of the OOO task role (common)."
}

output "task_role_ooo_name" {
  value       = [for role in aws_iam_role.task_role_ooo : role.name]
  description = "The name of the OOO task role (common)."
}

output "task_role_ooo_unique_id" {
  value       = [for role in aws_iam_role.task_role_ooo : role.unique_id]
  description = "The unique ID of the OOO task role (common)."
}

output "task_role_ooo_assume_policy_doc" {
  value       = [for role in aws_iam_role.task_role_ooo : role.assume_role_policy]
  description = "The IAM policy document of the OOO task role (common)."
}

output "task_role_custom_id" {
  value       = [for role in aws_iam_role.task_role_custom : role.id]
  description = "The ID of the custom task role."
}

output "task_role_custom_arn" {
  value       = [for role in aws_iam_role.task_role_custom : role.arn]
  description = "The ARN of the custom task role."
}

output "task_role_custom_name" {
  value       = [for role in aws_iam_role.task_role_custom : role.name]
  description = "The name of the custom task role."
}

output "task_role_custom_unique_id" {
  value       = [for role in aws_iam_role.task_role_custom : role.unique_id]
  description = "The unique ID of the custom task role."
}

output "task_role_custom_assume_policy_doc" {
  value       = [for role in aws_iam_role.task_role_custom : role.assume_role_policy]
  description = "The IAM policy document of the custom task role."
}
