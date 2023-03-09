<!-- BEGIN_TF_DOCS -->
# ☁️ ECS Role generator
## Description
Execution role
This module is able to create IAM roles (either execution roles, or task roles) for ECS tasks, and attach the required policies to them.
* 🚀 Create ecs execution roles, with out-of-the-box policies attached.
* 🚀 Create ecs task roles, with out-of-the-box policies attached.
* 🚀 Create custom ecs execution roles with custom policies attached.
* 🚀 Create custom ecs task roles with custom policies attached.

---
## Example
Examples of this module's usage are available in the [examples](./examples) folder.

```hcl
module "main_module" {
  source     = "../../../modules/ecs-roles"
  is_enabled = var.is_enabled
  aws_region = var.aws_region

  execution_role_ooo_config         = var.execution_role_ooo_config
  execution_role_config             = var.execution_role_config
  execution_role_permissions_config = var.execution_role_permissions_config
  task_role_ooo_config              = var.task_role_ooo_config
  task_role_config                  = var.task_role_config
  task_role_permissions_config      = var.task_role_permissions_config
}
```

Several examples that implement this module in different scenarios:
```hcl
aws_region = "us-east-1"
is_enabled = true

execution_role_ooo_config = [
  {
    name                   = "test"
    enable_ooo_role_common = true
  }
]
```

```hcl
aws_region = "us-east-1"
is_enabled = true

execution_role_config = [
  {
    name = "test"
  }
]

execution_role_permissions_config = [
  {
    resources                      = ["*"]
    policy_name                    = "pol1"
    role_name                      = "test"
    merge_with_default_permissions = true
    actions                        = ["*"]
    type                           = "Deny"
  },
  {
    resources                      = ["*"]
    policy_name                    = "pol2"
    role_name                      = "test"
    merge_with_default_permissions = false
    actions                        = ["ec2:Describe*", "ec2:CreateTags"]
    type                           = "Allow"
  }
]
```

```hcl
aws_region = "us-east-1"
is_enabled = true

task_role_config = [
  {
    name = "test"
  }
]

task_role_permissions_config = [
  {
    resources                      = ["*"]
    policy_name                    = "pol1"
    role_name                      = "test"
    merge_with_default_permissions = true
    actions                        = ["*"]
    type                           = "Deny"
  },
  {
    resources                      = ["*"]
    policy_name                    = "pol2"
    role_name                      = "test"
    merge_with_default_permissions = false
    actions                        = ["ec2:Describe*", "ec2:CreateTags"]
    type                           = "Allow"
  }
]
```

```hcl
aws_region = "us-east-1"
is_enabled = true

task_role_ooo_config = [
  {
    name = "test"
    enable_ooo_role_common  = false
    enable_ooo_role_fargate = true
  }
]
```


```hcl
aws_region = "us-east-1"
is_enabled = true

execution_role_ooo_config = [
  {
    name                    = "test"
    enable_ooo_role_fargate = true
  }
]
```


For module composition, It's recommended to take a look at the module's `outputs` to understand what's available:
```hcl
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

output "task_role_ooo_id"{
  value       = [for role in aws_iam_role.task_role_ooo : role.id]
  description = "The ID of the OOO task role (common)."
}

output "task_role_ooo_arn"{
  value       = [for role in aws_iam_role.task_role_ooo : role.arn]
  description = "The ARN of the OOO task role (common)."
}

output "task_role_ooo_name"{
  value       = [for role in aws_iam_role.task_role_ooo : role.name]
  description = "The name of the OOO task role (common)."
}

output "task_role_ooo_unique_id"{
  value       = [for role in aws_iam_role.task_role_ooo : role.unique_id]
  description = "The unique ID of the OOO task role (common)."
}

output "task_role_ooo_assume_policy_doc"{
  value       = [for role in aws_iam_role.task_role_ooo : role.assume_role_policy]
  description = "The IAM policy document of the OOO task role (common)."
}

output "task_role_custom_id"{
  value       = [for role in aws_iam_role.task_role_custom : role.id]
  description = "The ID of the custom task role."
}

output "task_role_custom_arn"{
  value       = [for role in aws_iam_role.task_role_custom : role.arn]
  description = "The ARN of the custom task role."
}

output "task_role_custom_name"{
  value       = [for role in aws_iam_role.task_role_custom : role.name]
  description = "The name of the custom task role."
}

output "task_role_custom_unique_id"{
  value       = [for role in aws_iam_role.task_role_custom : role.unique_id]
  description = "The unique ID of the custom task role."
}

output "task_role_custom_assume_policy_doc"{
  value       = [for role in aws_iam_role.task_role_custom : role.assume_role_policy]
  description = "The IAM policy document of the custom task role."
}
```
---

## Module's documentation
(This documentation is auto-generated using [terraform-docs](https://terraform-docs.io))
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.57.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_policy_execution_role_custom"></a> [iam\_policy\_execution\_role\_custom](#module\_iam\_policy\_execution\_role\_custom) | git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy | v0.49.0 |
| <a name="module_iam_policy_execution_role_custom_attachment"></a> [iam\_policy\_execution\_role\_custom\_attachment](#module\_iam\_policy\_execution\_role\_custom\_attachment) | git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy-attacher | v0.49.0 |
| <a name="module_iam_policy_execution_role_ooo_common"></a> [iam\_policy\_execution\_role\_ooo\_common](#module\_iam\_policy\_execution\_role\_ooo\_common) | git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy | v0.49.0 |
| <a name="module_iam_policy_execution_role_ooo_common_attachment"></a> [iam\_policy\_execution\_role\_ooo\_common\_attachment](#module\_iam\_policy\_execution\_role\_ooo\_common\_attachment) | git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy-attacher | v0.49.0 |
| <a name="module_iam_policy_execution_role_ooo_fargate"></a> [iam\_policy\_execution\_role\_ooo\_fargate](#module\_iam\_policy\_execution\_role\_ooo\_fargate) | git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy | v0.49.0 |
| <a name="module_iam_policy_execution_role_ooo_fargate_attachment"></a> [iam\_policy\_execution\_role\_ooo\_fargate\_attachment](#module\_iam\_policy\_execution\_role\_ooo\_fargate\_attachment) | git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy-attacher | v0.49.0 |
| <a name="module_iam_policy_task_role_custom"></a> [iam\_policy\_task\_role\_custom](#module\_iam\_policy\_task\_role\_custom) | git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy | v0.49.0 |
| <a name="module_iam_policy_task_role_custom_attachment"></a> [iam\_policy\_task\_role\_custom\_attachment](#module\_iam\_policy\_task\_role\_custom\_attachment) | git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy-attacher | v0.49.0 |
| <a name="module_iam_policy_task_role_ooo_common"></a> [iam\_policy\_task\_role\_ooo\_common](#module\_iam\_policy\_task\_role\_ooo\_common) | git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy | v0.49.0 |
| <a name="module_iam_policy_task_role_ooo_common_attachment"></a> [iam\_policy\_task\_role\_ooo\_common\_attachment](#module\_iam\_policy\_task\_role\_ooo\_common\_attachment) | git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy-attacher | v0.49.0 |
| <a name="module_iam_policy_task_role_ooo_fargate"></a> [iam\_policy\_task\_role\_ooo\_fargate](#module\_iam\_policy\_task\_role\_ooo\_fargate) | git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy | v0.49.0 |
| <a name="module_iam_policy_task_role_ooo_fargate_attachment"></a> [iam\_policy\_task\_role\_ooo\_fargate\_attachment](#module\_iam\_policy\_task\_role\_ooo\_fargate\_attachment) | git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy-attacher | v0.49.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.execution_role_custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.execution_role_ooo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task_role_custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task_role_ooo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_policy_document.execution_role_custom_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.execution_role_ooo_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_role_custom_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_role_ooo_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48.0, < 5.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_execution_role_config"></a> [execution\_role\_config](#input\_execution\_role\_config) | A list of objects that contains the settings for the custom execution role, compatible<br>with ECS (Task or ECS service).<br>The current attributes that are supported are:<br>- name: The unique identifier of this resource.<br>- role\_name: The name of the role. If it's not passed, it'll take the name passed<br>  in the "name" attribute.<br>- permissions\_boundary: The ARN of the policy that is used to set the permissions | <pre>list(object({<br>    name                 = string<br>    role_name            = optional(string, null)<br>    permissions_boundary = optional(string, null)<br>  }))</pre> | `null` | no |
| <a name="input_execution_role_ooo_config"></a> [execution\_role\_ooo\_config](#input\_execution\_role\_ooo\_config) | A list of objects that contains the settings for the Out-of-the-box execution role, compatible<br>with ECS (Task or ECS service).<br>The current attributes that are supported are:<br>- name: The unique identifier of this resource.<br>- role\_name: The name of the role. If it's not passed, it'll take the name passed<br>  in the "name" attribute.<br>- permissions\_boundary: The ARN of the policy that is used to set the permissions<br>- enable\_ooo\_role\_common: Whether to enable the Out-of-the-box role for ECS<br>  (Task or ECS service) with common permissions.<br>- enable\_ooo\_role\_fargate: Whether to enable the Out-of-the-box role for ECS<br>  (Task or ECS service) with Fargate permissions. | <pre>list(object({<br>    // General settings<br>    name                    = string<br>    role_name               = optional(string, null)<br>    permissions_boundary    = optional(string, null)<br>    enable_ooo_role_common  = optional(bool, false)<br>    enable_ooo_role_fargate = optional(bool, false)<br>  }))</pre> | `null` | no |
| <a name="input_execution_role_permissions_config"></a> [execution\_role\_permissions\_config](#input\_execution\_role\_permissions\_config) | A list of objects that contains the settings for the permissions that will be attached<br>to the execution role, compatible with ECS (Task or ECS service).<br>The current attributes that are supported are:<br>- role\_name: The name of the role. If it's not passed, it'll take the name passed<br>  in the "name" attribute.<br>- resources: The ARN of the resource that will be attached to the role.<br>- policy\_name: The name of the policy that will be attached to the role. It's required for uniqueness of the underlying module.<br>- permissions: A list of strings that contains the permissions that will be<br>  attached to the role.<br>- actions: The action that will be performed with the permissions. The default<br>- merge\_with\_default\_permissions: Whether to merge the permissions passed in<br>  this attribute with the default permissions. The default value is false.<br>- type: The type of the permission. The default value is "allow". | <pre>list(object({<br>    role_name                      = string<br>    policy_name                    = string<br>    resources                      = optional(list(string), ["*"])<br>    merge_with_default_permissions = optional(bool, false)<br>    actions                        = optional(list(string), ["*"])<br>    type                           = optional(string, "allow")<br>  }))</pre> | `null` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Whether this module will be created or not. It is useful, for stack-composite<br>modules that conditionally includes resources provided by this module.. | `bool` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_task_role_config"></a> [task\_role\_config](#input\_task\_role\_config) | A list of objects that contains the settings for the Out-of-the-box task role, compatible<br>with ECS to be used as a task role (task\_role\_arn if it's used in a task definition)<br>The current attributes that are supported are:<br>- name: The unique identifier of this resource.<br>- role\_name: The name of the role. If it's not passed, it'll take the name passed<br>  in the "name" attribute.<br>- permissions\_boundary: The ARN of the policy that is used to set the permissions | <pre>list(object({<br>    name                 = string<br>    role_name            = optional(string, null)<br>    permissions_boundary = optional(string, null)<br>  }))</pre> | `null` | no |
| <a name="input_task_role_ooo_config"></a> [task\_role\_ooo\_config](#input\_task\_role\_ooo\_config) | A list of objects that contains the settings for the Out-of-the-box task role, compatible<br>with ECS to be used as a task role (task\_role\_arn if it's used in a task definition)<br>The current attributes that are supported are:<br>- name: The unique identifier of this resource.<br>- role\_name: The name of the role. If it's not passed, it'll take the name passed<br>  in the "name" attribute.<br>- permissions\_boundary: The ARN of the policy that is used to set the permissions<br>- enable\_ooo\_role\_common: Whether to enable the Out-of-the-box role for ECS<br>  (Task or ECS service) with common permissions.<br>- enable\_ooo\_role\_fargate: Whether to enable the Out-of-the-box role for ECS<br>  (Task or ECS service) with Fargate permissions. | <pre>list(object({<br>    name                    = string<br>    role_name               = optional(string, null)<br>    permissions_boundary    = optional(string, null)<br>    enable_ooo_role_common  = optional(bool, false)<br>    enable_ooo_role_fargate = optional(bool, false)<br>  }))</pre> | `null` | no |
| <a name="input_task_role_permissions_config"></a> [task\_role\_permissions\_config](#input\_task\_role\_permissions\_config) | A list of objects that contains the settings for the permissions that will be attached<br>to the task role, compatible with ECS (Task or ECS service).<br>The current attributes that are supported are:<br>- role\_name: The name of the role. If it's not passed, it'll take the name passed<br>  in the "name" attribute.<br>- resources: The ARN of the resource that will be attached to the role.<br>- policy\_name: The name of the policy that will be attached to the role. It's required for uniqueness of the underlying module.<br>- permissions: A list of strings that contains the permissions that will be<br>  attached to the role.<br>- actions: The action that will be performed with the permissions. The default<br>- merge\_with\_default\_permissions: Whether to merge the permissions passed in<br>  this attribute with the default permissions. The default value is false.<br>- type: The type of the permission. The default value is "allow". | <pre>list(object({<br>    role_name                      = string<br>    policy_name                    = string<br>    resources                      = optional(list(string), ["*"])<br>    merge_with_default_permissions = optional(bool, false)<br>    actions                        = optional(list(string), ["*"])<br>    type                           = optional(string, "allow")<br>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region_for_deploy_this"></a> [aws\_region\_for\_deploy\_this](#output\_aws\_region\_for\_deploy\_this) | The AWS region where the module is deployed. |
| <a name="output_execution_role_custom_arn"></a> [execution\_role\_custom\_arn](#output\_execution\_role\_custom\_arn) | The ARN of the custom execution role. |
| <a name="output_execution_role_custom_assume_policy_doc"></a> [execution\_role\_custom\_assume\_policy\_doc](#output\_execution\_role\_custom\_assume\_policy\_doc) | The IAM policy document of the custom execution role. |
| <a name="output_execution_role_custom_id"></a> [execution\_role\_custom\_id](#output\_execution\_role\_custom\_id) | The ID of the custom execution role. |
| <a name="output_execution_role_custom_name"></a> [execution\_role\_custom\_name](#output\_execution\_role\_custom\_name) | The name of the custom execution role. |
| <a name="output_execution_role_custom_unique_id"></a> [execution\_role\_custom\_unique\_id](#output\_execution\_role\_custom\_unique\_id) | The unique ID of the custom execution role. |
| <a name="output_execution_role_ooo_arn"></a> [execution\_role\_ooo\_arn](#output\_execution\_role\_ooo\_arn) | The ARN of the OOO execution role (common). |
| <a name="output_execution_role_ooo_assume_policy_doc"></a> [execution\_role\_ooo\_assume\_policy\_doc](#output\_execution\_role\_ooo\_assume\_policy\_doc) | The IAM policy document of the OOO execution role (common). |
| <a name="output_execution_role_ooo_id"></a> [execution\_role\_ooo\_id](#output\_execution\_role\_ooo\_id) | The ID of the OOO execution role (common). |
| <a name="output_execution_role_ooo_name"></a> [execution\_role\_ooo\_name](#output\_execution\_role\_ooo\_name) | The name of the OOO execution role (common). |
| <a name="output_execution_role_ooo_unique_id"></a> [execution\_role\_ooo\_unique\_id](#output\_execution\_role\_ooo\_unique\_id) | The unique ID of the OOO execution role (common). |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the module is enabled or not. |
| <a name="output_tags_set"></a> [tags\_set](#output\_tags\_set) | The tags set for the module. |
| <a name="output_task_role_custom_arn"></a> [task\_role\_custom\_arn](#output\_task\_role\_custom\_arn) | The ARN of the custom task role. |
| <a name="output_task_role_custom_assume_policy_doc"></a> [task\_role\_custom\_assume\_policy\_doc](#output\_task\_role\_custom\_assume\_policy\_doc) | The IAM policy document of the custom task role. |
| <a name="output_task_role_custom_id"></a> [task\_role\_custom\_id](#output\_task\_role\_custom\_id) | The ID of the custom task role. |
| <a name="output_task_role_custom_name"></a> [task\_role\_custom\_name](#output\_task\_role\_custom\_name) | The name of the custom task role. |
| <a name="output_task_role_custom_unique_id"></a> [task\_role\_custom\_unique\_id](#output\_task\_role\_custom\_unique\_id) | The unique ID of the custom task role. |
| <a name="output_task_role_ooo_arn"></a> [task\_role\_ooo\_arn](#output\_task\_role\_ooo\_arn) | The ARN of the OOO task role (common). |
| <a name="output_task_role_ooo_assume_policy_doc"></a> [task\_role\_ooo\_assume\_policy\_doc](#output\_task\_role\_ooo\_assume\_policy\_doc) | The IAM policy document of the OOO task role (common). |
| <a name="output_task_role_ooo_id"></a> [task\_role\_ooo\_id](#output\_task\_role\_ooo\_id) | The ID of the OOO task role (common). |
| <a name="output_task_role_ooo_name"></a> [task\_role\_ooo\_name](#output\_task\_role\_ooo\_name) | The name of the OOO task role (common). |
| <a name="output_task_role_ooo_unique_id"></a> [task\_role\_ooo\_unique\_id](#output\_task\_role\_ooo\_unique\_id) | The unique ID of the OOO task role (common). |
<!-- END_TF_DOCS -->