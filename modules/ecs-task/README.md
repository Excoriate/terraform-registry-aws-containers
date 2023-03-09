<!-- BEGIN_TF_DOCS -->
# ☁️ ECS Task definition module.
## Description

This module creates an ECS task definition with the specified name.
* 🚀 **ECS task definition**: ECS task definition with the specified name.
* 🚀 **ECS task definition revision**: ECS task definition revision with the specified name.

This module pretends to be used as a safer way to create ECS task definitions, by using the `terraform` way to create them, and parsing the resulting object as a valid .json
that can be used in an ECS service.

---
## Example
Examples of this module's usage are available in the [examples](./examples) folder.

```hcl
module "main_module" {
  source     = "../../../modules/ecs-task"
  is_enabled = var.is_enabled
  aws_region = var.aws_region

  task_config = [
    {
      name = "task1"
      container_definition_from_json = jsonencode([
        {
          name               = "app"
          image              = "cloudposse/geodesic"
          essential          = true
          interactive        = true
          pseudo_terminal    = true
          cpu                = 256
          memory             = 256
          memory_reservation = 128
          log_configuration = {
            log_driver = "json-file"
            options = {
              "max-file" = "3"
              "max-size" = "10m"
            }
          }
          port_mappings = [
            {
              container_port = 8080
              host_port      = 80
              protocol       = "tcp"
            },
            {
              container_port = 8081
              host_port      = 443
              protocol       = "udp"
            },
          ]
          extra_hosts = [
            {
              hostname   = "app.local"
              ip_address = "127.0.0.1"
            },
          ]
          mount_points              = []
          volumes_from              = []
          privileged                = false
          read_only_root_filesystem = false
        }
      ])
    },
    // Task 2
    {
      name = "task2"
      container_definition_from_json = jsonencode([
        {
          name               = "app"
          image              = "cloudposse/geodesic"
          essential          = true
          interactive        = true
          pseudo_terminal    = false
          cpu                = 256
          memory             = 256
          memory_reservation = 128
          log_configuration = {
            log_driver = "json-file"
            options = {
              "max-file" = "3"
              "max-size" = "10m"
            }
          }
          port_mappings = [
            {
              container_port = 8080
              host_port      = 80
              protocol       = "tcp"
            },
            {
              container_port = 8081
              host_port      = 443
              protocol       = "udp"
            },
          ]
          extra_hosts = [
            {
              hostname   = "app.local"
              ip_address = "127.0.0.1"
            },
          ]
          mount_points              = []
          volumes_from              = []
          privileged                = false
          read_only_root_filesystem = false
        }
      ])
    },
    // Task 3 with extra IAM policies.
    {
      name = "task3"
      enable_extra_iam_policies_arn = [
      aws_iam_policy.test_extra_iam_policy.arn]
      container_definition_from_json = jsonencode([
        {
          name               = "app"
          image              = "cloudposse/geodesic"
          essential          = true
          interactive        = true
          pseudo_terminal    = false
          cpu                = 256
          memory             = 256
          memory_reservation = 128
          log_configuration = {
            log_driver = "json-file"
            options = {
              "max-file" = "3"
              "max-size" = "10m"
            }
          }
          port_mappings = [
            {
              container_port = 8080
              host_port      = 80
              protocol       = "tcp"
            },
            {
              container_port = 8081
              host_port      = 443
              protocol       = "udp"
            },
          ]
          extra_hosts = [
            {
              hostname   = "app.local"
              ip_address = "127.0.0.1"
            },
          ]
          mount_points              = []
          volumes_from              = []
          privileged                = false
          read_only_root_filesystem = false
        }
      ])
    }
  ]

  task_extra_iam_policies = [
    {
      task_name  = "task3"
      policy_arn = aws_iam_policy.test_extra_iam_policy.arn
    }
  ]
}


resource "aws_iam_policy" "test_extra_iam_policy" {
  name   = "test_extra_iam_policy"
  policy = data.aws_iam_policy_document.test_extra_iam_policy_doc.json
}

data "aws_iam_policy_document" "test_extra_iam_policy_doc" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:Describe*",
    ]
  }
}
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
output "ecs_task_definition_arn" {
  value       = [for t in aws_ecs_task_definition.this : t.arn]
  description = "The ARN of the task definition."
}

output "ecs_task_definition_family" {
  value       = [for t in aws_ecs_task_definition.this : t.family]
  description = "The family of the task definition."
}

output "ecs_task_definition_revision" {
  value       = [for t in aws_ecs_task_definition.this : t.revision]
  description = "The revision of the task definition."
}

output "ecs_task_definition_task_role_arn" {
  value       = [for t in aws_ecs_task_definition.this : t.task_role_arn]
  description = "The ARN of the IAM role that grants containers in the task permission to call AWS APIs on your behalf."
}

output "ecs_task_definition_execution_role_arn" {
  value       = [for t in aws_ecs_task_definition.this : t.execution_role_arn]
  description = "The ARN of the IAM role that grants the Amazon ECS container agent permission to make AWS API calls on your behalf."
}

output "ecs_task_definition_network_mode" {
  value       = [for t in aws_ecs_task_definition.this : t.network_mode]
  description = "The network mode of the task definition."
}

output "ecs_task_definition_container_definitions" {
  value       = [for t in aws_ecs_task_definition.this : t.container_definitions]
  description = "The container definitions of the task definition."
}

output "ecs_task_definition_cpu" {
  value       = [for t in aws_ecs_task_definition.this : t.cpu]
  description = "The number of CPU units used by the task."
}

output "ecs_task_definition_memory" {
  value       = [for t in aws_ecs_task_definition.this : t.memory]
  description = "The amount (in MiB) of memory used by the task."
}

output "ecs_task_definition_proxy_configuration" {
  value       = [for t in aws_ecs_task_definition.this : t.proxy_configuration]
  description = "The proxy configuration of the task definition."
}

// FIXME: Fix this functionality later.
output "is_extra_iam_policies_passed"{
  value = local.extra_iam_policies
  description = "Whether the extra IAM policies are passed or not."
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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |

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
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Whether this module will be created or not. It is useful, for stack-composite<br>modules that conditionally includes resources provided by this module.. | `bool` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_task_config"></a> [task\_config](#input\_task\_config) | A list of objects that contains the configuration for each task definition.<br>The currently supported attributes are:<br>- name: The name of the task definition.<br>- family: The family of the task definition. If not provided, it'll use the name.<br>- container\_definition\_from\_json: The JSON string that contains the container definition.<br>- container\_definition\_from\_file: The path to the file that contains the container definition.<br>- type: The type of the task definition. Valid values are: EC2, FARGATE. Default: FARGATE.<br>- network\_mode: The network mode of the task definition. Valid values are: awsvpc, bridge, host, none. Default: awsvpc.<br>- cpu: The number of CPU units to reserve for the container. Default: 256.<br>- memory: The amount of memory (in MiB) to allow the container to use. Default: 512.<br>- task\_role\_arn: The ARN of the IAM role that allows your Amazon ECS container task to make calls to other AWS services.<br>- execution\_role\_arn: The ARN of the IAM role that allows your Amazon ECS container task to make calls to other AWS services.<br>- permissions\_boundary: The ARN of the policy that is used to set the permissions boundary for the task role. | <pre>list(object({<br>    // General settings<br>    name                           = string<br>    family                         = optional(string, null)<br>    container_definition_from_json = optional(string, null)<br>    container_definition_from_file = optional(string, null)<br>    type                           = optional(string, "FARGATE")<br>    network_mode                   = optional(string, null)<br>    // Capacity<br>    cpu    = optional(number, 256)<br>    memory = optional(number, 512)<br>    // Permissions<br>    task_role_arn              = optional(string, null) // If null, it'll create the IAM Role as part of this module.<br>    execution_role_arn        = optional(string, null) // If null, it'll create the IAM Role as part of this module.<br>    permissions_boundary       = optional(string, null)<br>    // proxy_configuration<br>    proxy_configuration = optional(object({<br>      type           = string<br>      container_name = string<br>      properties = optional(list(object({<br>        name  = string<br>        value = string<br>      })), [])<br>    }), null)<br>    // Ephemeral storage<br>    ephemeral_storage = optional(number, null)<br>  }))</pre> | `null` | no |
| <a name="input_task_extra_iam_policies"></a> [task\_extra\_iam\_policies](#input\_task\_extra\_iam\_policies) | A list of objects that contains the configuration for each extra IAM policy.<br>The currently supported attributes are:<br>- task\_name: The name of the task definition.<br>- policy\_arn: The ARN of the policy.<br>- role\_name: The name of the role to attach the policy to. If not provided, it'll use the task role. | <pre>list(object({<br>    task_name  = string<br>    policy_arn = string<br>    role_name  = optional(string, null)<br>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region_for_deploy_this"></a> [aws\_region\_for\_deploy\_this](#output\_aws\_region\_for\_deploy\_this) | The AWS region where the module is deployed. |
| <a name="output_ecs_task_definition_arn"></a> [ecs\_task\_definition\_arn](#output\_ecs\_task\_definition\_arn) | The ARN of the task definition. |
| <a name="output_ecs_task_definition_container_definitions"></a> [ecs\_task\_definition\_container\_definitions](#output\_ecs\_task\_definition\_container\_definitions) | The container definitions of the task definition. |
| <a name="output_ecs_task_definition_cpu"></a> [ecs\_task\_definition\_cpu](#output\_ecs\_task\_definition\_cpu) | The number of CPU units used by the task. |
| <a name="output_ecs_task_definition_execution_role_arn"></a> [ecs\_task\_definition\_execution\_role\_arn](#output\_ecs\_task\_definition\_execution\_role\_arn) | The ARN of the IAM role that grants the Amazon ECS container agent permission to make AWS API calls on your behalf. |
| <a name="output_ecs_task_definition_family"></a> [ecs\_task\_definition\_family](#output\_ecs\_task\_definition\_family) | The family of the task definition. |
| <a name="output_ecs_task_definition_memory"></a> [ecs\_task\_definition\_memory](#output\_ecs\_task\_definition\_memory) | The amount (in MiB) of memory used by the task. |
| <a name="output_ecs_task_definition_network_mode"></a> [ecs\_task\_definition\_network\_mode](#output\_ecs\_task\_definition\_network\_mode) | The network mode of the task definition. |
| <a name="output_ecs_task_definition_proxy_configuration"></a> [ecs\_task\_definition\_proxy\_configuration](#output\_ecs\_task\_definition\_proxy\_configuration) | The proxy configuration of the task definition. |
| <a name="output_ecs_task_definition_revision"></a> [ecs\_task\_definition\_revision](#output\_ecs\_task\_definition\_revision) | The revision of the task definition. |
| <a name="output_ecs_task_definition_task_role_arn"></a> [ecs\_task\_definition\_task\_role\_arn](#output\_ecs\_task\_definition\_task\_role\_arn) | The ARN of the IAM role that grants containers in the task permission to call AWS APIs on your behalf. |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the module is enabled or not. |
| <a name="output_is_extra_iam_policies_passed"></a> [is\_extra\_iam\_policies\_passed](#output\_is\_extra\_iam\_policies\_passed) | Whether the extra IAM policies are passed or not. |
| <a name="output_tags_set"></a> [tags\_set](#output\_tags\_set) | The tags set for the module. |
<!-- END_TF_DOCS -->
