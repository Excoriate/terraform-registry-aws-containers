<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48.0, < 5.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_main_module"></a> [main\_module](#module\_main\_module) | ../../../modules/ecs-roles | n/a |

## Resources

No resources.

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