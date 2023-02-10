<!-- BEGIN_TF_DOCS -->
# ☁️ ECS cluster module
## Description

This module creates an ECS cluster with the following features:
* 🚀 **ECS cluster**: ECS cluster with the specified name.
* 🚀 **ECS cluster capacity provider**: ECS cluster capacity provider with the specified name.
* 🚀 **ECS cluster capacity provider strategy**: ECS cluster capacity provider strategy with the specified name.

---
## Example
Examples of this module's usage are available in the [examples](./examples) folder.

```hcl
module "main_module" {
  source             = "../../../modules/ecs-cluster"
  is_enabled         = var.is_enabled
  aws_region         = var.aws_region
  ecs_cluster_config = var.ecs_cluster_config
}
```
```hcl
aws_region = "us-east-1"
is_enabled = true

ecs_cluster_config = [
  {
    name = "cluster-test"
  },
  {
    name                      = "cluster-test-2"
    enable_container_insights = true
  }
]
```

An example of multiple clusters, created at once with some of them using capacity providers:
```hcl
aws_region = "us-east-1"
is_enabled = true

ecs_cluster_config = [
  {
    name = "cluster-test"
  },
  {
    name                      = "cluster-test-2"
    enable_container_insights = true
  },
  {
    name                      = "cluster-test-cp"
    enable_container_insights = true
    providers = {
      type = "FARGATE"
    }
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
// FIXME: Remove, refactor or change. (Template)
```
---

## Module's documentation
(This documentation is auto-generated using [terraform-docs](https://terraform-docs.io))
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.54.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |

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
| <a name="input_ecs_cluster_config"></a> [ecs\_cluster\_config](#input\_ecs\_cluster\_config) | Configuration for the ECS cluster. The allowed parameters are:<br>  - name: The name of the ECS cluster.<br>  - enable\_container\_insights: Whether to enable CloudWatch Container Insights for the ECS cluster.<br>  - providers: The capacity providers to associate with the cluster.<br>  - cluster\_configuration: The execute command configuration for the cluster. | <pre>list(object({<br>    name                      = string<br>    enable_container_insights = optional(bool, false)<br>    providers = optional(object({<br>      type = optional(string, "FARGATE_SPOT")<br>      default_capacity_provider_strategy = optional(list(object({<br>        capacity_provider = optional(string, "FARGATE_SPOT")<br>        weight            = optional(number, 1)<br>        base              = optional(number, 0)<br>      })), null)<br>    }), null)<br>    cluster_configuration = optional(object({<br>      execute_command_configuration = optional(object({<br>        kms_key_id = optional(string, null)<br>        logging    = optional(string, null)<br>      }), null)<br>    }), null)<br>  }))</pre> | `null` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Whether this module will be created or not. It is useful, for stack-composite<br>modules that conditionally includes resources provided by this module.. | `bool` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region_for_deploy_this"></a> [aws\_region\_for\_deploy\_this](#output\_aws\_region\_for\_deploy\_this) | The AWS region where the module is deployed. |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the module is enabled or not. |
| <a name="output_tags_set"></a> [tags\_set](#output\_tags\_set) | The tags set for the module. |
<!-- END_TF_DOCS -->
