output "is_enabled" {
  value       = var.is_enabled
  description = "Whether the module is enabled or not."
}

output "aws_region_for_deploy_this" {
  value       = module.main_module.aws_region_for_deploy_this
  description = "The AWS region where the module is deployed."
}


/*
-------------------------------------
Custom outputs
-------------------------------------
*/
output "execution_role_ooo_id" {
  value       = module.main_module.execution_role_ooo_id
  description = "The ID of the OOO execution role (common)."
}

output "execution_role_ooo_arn" {
  value       = module.main_module.execution_role_ooo_arn
  description = "The ARN of the OOO execution role (common)."
}

output "execution_role_ooo_name" {
  value       = module.main_module.execution_role_ooo_name
  description = "The name of the OOO execution role (common)."
}

output "execution_role_ooo_unique_id" {
  value       = module.main_module.execution_role_ooo_unique_id
  description = "The unique ID of the OOO execution role (common)."
}

output "execution_role_ooo_assume_policy_doc" {
  value       = module.main_module.execution_role_ooo_assume_policy_doc
  description = "The IAM policy document of the OOO execution role (common)."
}

output "execution_role_custom_id" {
  value       = module.main_module.execution_role_custom_id
  description = "The ID of the custom execution role."
}

output "execution_role_custom_arn" {
  value       = module.main_module.execution_role_custom_arn
  description = "The ARN of the custom execution role."
}

output "execution_role_custom_name" {
  value       = module.main_module.execution_role_custom_name
  description = "The name of the custom execution role."
}

output "execution_role_custom_unique_id" {
  value       = module.main_module.execution_role_custom_unique_id
  description = "The unique ID of the custom execution role."
}

output "execution_role_custom_assume_policy_doc" {
  value       = module.main_module.execution_role_custom_assume_policy_doc
  description = "The IAM policy document of the custom execution role."
}

output "task_role_ooo_id" {
  value       = module.main_module.task_role_ooo_id
  description = "The ID of the OOO task role (common)."
}

output "task_role_ooo_arn" {
  value       = module.main_module.task_role_ooo_arn
  description = "The ARN of the OOO task role (common)."
}

output "task_role_ooo_name" {
  value       = module.main_module.task_role_ooo_name
  description = "The name of the OOO task role (common)."
}

output "task_role_ooo_unique_id" {
  value       = module.main_module.task_role_ooo_unique_id
  description = "The unique ID of the OOO task role (common)."
}

output "task_role_ooo_assume_policy_doc" {
  value       = module.main_module.task_role_ooo_assume_policy_doc
  description = "The IAM policy document of the OOO task role (common)."
}

output "task_role_custom_id" {
  value       = module.main_module.task_role_custom_id
  description = "The ID of the custom task role."
}

output "task_role_custom_arn" {
  value       = module.main_module.task_role_custom_arn
  description = "The ARN of the custom task role."
}

output "task_role_custom_name" {
  value       = module.main_module.task_role_custom_name
  description = "The name of the custom task role."
}

output "task_role_custom_unique_id" {
  value       = module.main_module.task_role_custom_unique_id
  description = "The unique ID of the custom task role."
}

output "task_role_custom_assume_policy_doc" {
  value       = module.main_module.task_role_custom_assume_policy_doc
  description = "The IAM policy document of the custom task role."
}
