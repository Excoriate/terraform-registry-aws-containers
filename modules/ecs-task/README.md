<!-- BEGIN_TF_DOCS -->
# ☁️ Auto-scaling module for ECS (services)
## Description

This module enables an auto-scaling strategy for an application or service that's intended to run on ECS (service).
* 🚀 **ECS service auto-scaling**: ECS service auto-scaling with the specified name.
* 🚀 **ECS service auto-scaling policy**: ECS service auto-scaling policy with the specified name.
* 🚀 **ECS service auto-scaling target**: ECS service auto-scaling target with the specified name.

Currently, this module doesnt' support other services, only `ECS service` for now. Future services will be added soon.

---
## Example
Examples of this module's usage are available in the [examples](./examples) folder.

```hcl
module "main_module" {
  source     = "../../../../modules/auto-scaling/app-auto-scaling"
  is_enabled = var.is_enabled
  aws_region = var.aws_region

  auto_scaling_config     = var.auto_scaling_config
  auto_scaling_ecs_config = var.auto_scaling_ecs_config
}
```
```hcl
aws_region = "us-east-1"
is_enabled = true

auto_scaling_config = [
  {
    name         = "auto-scaling-identifier"
    dimension    = "DesireCount"
    resource_id  = "mycluster/my-service"
    min_capacity = 1
    max_capacity = 10
    type         = "ecs"
  },
  {
    name         = "auto-scaling-another"
    dimension    = "DesireCount"
    resource_id  = "mycluster/my-service"
    min_capacity = 2
    max_capacity = 10
    type         = "ecs"
  }
]
```

```hcl
aws_region = "us-east-1"
is_enabled = true

auto_scaling_config = [
  {
    name         = "auto-scaling-identifier"
    dimension    = "DesireCount"
    resource_id  = "mycluster/my-service"
    min_capacity = 1
    max_capacity = 10
    type         = "ecs"
  },
  {
    name         = "auto-scaling-another"
    dimension    = "DesireCount"
    resource_id  = "mycluster/my-service"
    min_capacity = 2
    max_capacity = 10
    type         = "ecs"
  }
]

auto_scaling_ecs_config= [
  {
    // All the other are optionals, so it'll inherit the default values.
    name = "auto-scaling-identifier"
  },
  {
    name                = "auto-scaling-another"
    target_metric_value = 20
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
output "aws_region_for_deploy" {
  value       = local.aws_region_to_deploy
  description = "The AWS region where the module is deployed."
}

output "app_autoscaling_ecs_id" {
  value       = [for ac in aws_appautoscaling_target.ecs_target : ac.id]
  description = "The ID of the application autoscaling target for ECS."
}

output "app_autoscaling_ecs_role_arn" {
  value       = [for ac in aws_appautoscaling_target.ecs_target : ac.role_arn]
  description = "The ARN of the application autoscaling target for ECS."
}

output "app_autoscaling_ecs_min_capacity" {
  value       = [for ac in aws_appautoscaling_target.ecs_target : ac.min_capacity]
  description = "The minimum capacity of the application autoscaling target for ECS."
}

output "app_autoscaling_ecs_max_capacity" {
  value       = [for ac in aws_appautoscaling_target.ecs_target : ac.max_capacity]
  description = "The maximum capacity of the application autoscaling target for ECS."
}

output "app_autoscaling_ecs_resource_id" {
  value       = [for ac in aws_appautoscaling_target.ecs_target : ac.resource_id]
  description = "The resource ID of the application autoscaling target for ECS."
}
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
| [aws_appautoscaling_policy.ecs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.ecs_scale_down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.ecs_scale_up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.ecs_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48.0, < 5.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_scaling_config"></a> [auto\_scaling\_config](#input\_auto\_scaling\_config) | A configuration object, that defines an auto-scaling configuration for an application in AWS. This object doesn't<br>define the auto-scaling specifics configuration. For such configurations, please refer to the input variable<br>'var.auto\_scaling\_ecs\_config' or the one that corresponds to the specific AWS application (DynamoDB, Aurora, ECS, etc.)<br>The current attributes that are supported are:<br>- name: Unique identifier for this auto-scaling configuration.<br>- type: The type of the auto-scaling configuration. E.g.: ecs, dynamodb, aurora.<br>- resource\_id: Unique identifier for this auto-scaling configuration.<br>- dimension: The dimension of the auto-scaling configuration.<br>- min\_capacity: The minimum capacity of the auto-scaling configuration.<br>- max\_capacity: The maximum capacity of the auto-scaling configuration.<br>- role\_arn: The ARN of the IAM role that allows Application Auto Scaling to modify your scalable target on your behalf. | <pre>list(object({<br>    name         = string<br>    type         = string<br>    resource_id  = string<br>    dimension    = string<br>    min_capacity = optional(number, 1)<br>    max_capacity = optional(number, 1)<br>    role_arn     = optional(string, null)<br>  }))</pre> | `null` | no |
| <a name="input_auto_scaling_ecs_config"></a> [auto\_scaling\_ecs\_config](#input\_auto\_scaling\_ecs\_config) | A configuration object, that defines an auto-scaling configuration for an application in AWS. This<br>  configuration is used to configure the auto-scaling for an application in AWS.<br>Current attributes supported:<br>- name: Unique identifier for this auto-scaling configuration.<br>- adjustment\_type: The adjustment type, which specifies how ScalingAdjustment is interpreted. Valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity.<br>- metric\_aggregation\_type: The aggregation type for the CloudWatch metrics. Valid values are Minimum, Maximum, and Average.<br>- scale\_up\_cool\_down: The amount of time, in seconds, after a scale in activity completes before another scale in activity can start.<br>- scale\_down\_cool\_down: The amount of time, in seconds, after a scale out activity completes before another scale out activity can start.<br>- scale\_up\_adjustment: The amount by which to scale, based on the specified adjustment type. A positive value adds to the current capacity while a negative number removes from the current capacity.<br>- scale\_down\_adjustment: The amount by which to scale, based on the specified adjustment type. A positive value adds to the current capacity while a negative number removes from the current capacity.<br>- target\_metric\_type: The metric type. The only valid value is ECSServiceAverageCPUUtilization.<br>- target\_metric\_value: The target value for the metric. | <pre>list(object({<br>    name                    = string<br>    adjustment_type         = optional(string, "ChangeInCapacity")<br>    metric_aggregation_type = optional(string, "Average")<br>    scale_up_cool_down      = optional(number, 60)<br>    scale_down_cool_down    = optional(number, 60)<br>    scale_up_adjustment     = optional(number, 1)<br>    scale_down_adjustment   = optional(number, -1)<br>    target_metric_type      = optional(string, "ECSServiceAverageCPUUtilization")<br>    target_metric_value     = optional(number, 50)<br>  }))</pre> | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Whether this module will be created or not. It is useful, for stack-composite<br>modules that conditionally includes resources provided by this module.. | `bool` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_autoscaling_ecs_id"></a> [app\_autoscaling\_ecs\_id](#output\_app\_autoscaling\_ecs\_id) | The ID of the application autoscaling target for ECS. |
| <a name="output_app_autoscaling_ecs_max_capacity"></a> [app\_autoscaling\_ecs\_max\_capacity](#output\_app\_autoscaling\_ecs\_max\_capacity) | The maximum capacity of the application autoscaling target for ECS. |
| <a name="output_app_autoscaling_ecs_min_capacity"></a> [app\_autoscaling\_ecs\_min\_capacity](#output\_app\_autoscaling\_ecs\_min\_capacity) | The minimum capacity of the application autoscaling target for ECS. |
| <a name="output_app_autoscaling_ecs_resource_id"></a> [app\_autoscaling\_ecs\_resource\_id](#output\_app\_autoscaling\_ecs\_resource\_id) | The resource ID of the application autoscaling target for ECS. |
| <a name="output_app_autoscaling_ecs_role_arn"></a> [app\_autoscaling\_ecs\_role\_arn](#output\_app\_autoscaling\_ecs\_role\_arn) | The ARN of the application autoscaling target for ECS. |
| <a name="output_aws_region_for_deploy"></a> [aws\_region\_for\_deploy](#output\_aws\_region\_for\_deploy) | The AWS region where the module is deployed. |
| <a name="output_aws_region_for_deploy_this"></a> [aws\_region\_for\_deploy\_this](#output\_aws\_region\_for\_deploy\_this) | The AWS region where the module is deployed. |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the module is enabled or not. |
| <a name="output_tags_set"></a> [tags\_set](#output\_tags\_set) | The tags set for the module. |
<!-- END_TF_DOCS -->
