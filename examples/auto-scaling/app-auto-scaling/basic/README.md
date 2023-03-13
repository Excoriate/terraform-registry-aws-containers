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
| <a name="module_main_module"></a> [main\_module](#module\_main\_module) | ../../../../modules/auto-scaling/app-auto-scaling | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_scaling_ecs_config"></a> [auto\_scaling\_ecs\_config](#input\_auto\_scaling\_ecs\_config) | A list of objects that contains the configuration for the auto scaling group. This object<br>defines the auto-scaling strategy for an ECS service. The allowed attributes are:<br>- name: The name of the auto scaling group.<br>- adjustment\_type: The adjustment type. Valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity.<br>- dimension: The dimension name. Valid values are DesiredCount, and InServiceCapacity.<br>- min\_capacity: The minimum capacity.<br>- max\_capacity: The maximum capacity.<br>- policy\_type: The policy type. Valid values are StepScaling and TargetTrackingScaling.<br>- cluster\_name: The name of the ECS cluster.<br>- service\_name: The name of the ECS service.<br>- scale\_up\_metric\_aggregation\_type: The aggregation type for the CloudWatch metrics. Valid values are Minimum, Maximum, and Average.<br>- scale\_up\_cool\_down: The amount of time, in seconds, after a scaling activity completes before any further trigger-related scaling activities can start.<br>- scale\_up\_adjustment: The number of instances by which to scale. AdjustmentType determines the interpretation of this number (e.g., as an absolute number or as a percentage of the existing Auto Scaling group size). A positive value adds to the current capacity and a negative number removes from the current capacity.<br>- scale\_down\_adjustment: The number of instances by which to scale. AdjustmentType determines the interpretation of this number (e.g., as an absolute number or as a percentage of the existing Auto Scaling group size). A positive value adds to the current capacity and a negative number removes from the current capacity.<br>- scale\_down\_metric\_aggregation\_type: The aggregation type for the CloudWatch metrics. Valid values are Minimum, Maximum, and Average.<br>- scale\_down\_cool\_down: The amount of time, in seconds, after a scaling activity completes before any further trigger-related scaling activities can start.<br>- target\_metric\_type: The metric type. Valid values are ECSServiceAverageCPUUtilization, ECSServiceAverageMemoryUtilization, ALBRequestCountPerTarget, and DynamoDBReadCapacityUtilization.<br>- target\_metric\_value: The target value for the metric.<br>- target\_metric\_policy\_type: The policy type. Valid values are StepScaling and TargetTrackingScaling. | <pre>list(object({<br>    name                               = string<br>    adjustment_type                    = optional(string, "ChangeInCapacity")<br>    dimension                          = optional(string, "DesiredCount")<br>    min_capacity                       = optional(number, 1)<br>    max_capacity                       = optional(number, 1)<br>    policy_type                        = optional(string, "StepScaling")<br>    cluster_name                       = string<br>    service_name                       = string<br>    scale_up_metric_aggregation_type   = optional(string, "Average")<br>    scale_up_cool_down                 = optional(number, 60)<br>    scale_up_adjustment                = optional(number, 1)<br>    scale_down_adjustment              = optional(number, -1)<br>    scale_down_metric_aggregation_type = optional(string, "Average")<br>    scale_down_cool_down               = optional(number, 60)<br>    target_metric_type                 = optional(string, "ECSServiceAverageCPUUtilization")<br>    target_metric_value                = optional(number, 50)<br>    target_metric_policy_type          = optional(string, "TargetTrackingScaling")<br>    role_arn                           = optional(string, null)<br>  }))</pre> | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Enable or disable the module | `bool` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_autoscaling_ecs_id"></a> [app\_autoscaling\_ecs\_id](#output\_app\_autoscaling\_ecs\_id) | The ID of the application autoscaling target for ECS. |
| <a name="output_app_autoscaling_ecs_max_capacity"></a> [app\_autoscaling\_ecs\_max\_capacity](#output\_app\_autoscaling\_ecs\_max\_capacity) | The maximum capacity of the application autoscaling target for ECS. |
| <a name="output_app_autoscaling_ecs_min_capacity"></a> [app\_autoscaling\_ecs\_min\_capacity](#output\_app\_autoscaling\_ecs\_min\_capacity) | The minimum capacity of the application autoscaling target for ECS. |
| <a name="output_app_autoscaling_ecs_resource_id"></a> [app\_autoscaling\_ecs\_resource\_id](#output\_app\_autoscaling\_ecs\_resource\_id) | The resource ID of the application autoscaling target for ECS. |
| <a name="output_app_autoscaling_ecs_role_arn"></a> [app\_autoscaling\_ecs\_role\_arn](#output\_app\_autoscaling\_ecs\_role\_arn) | The ARN of the application autoscaling target for ECS. |
| <a name="output_aws_region_for_deploy"></a> [aws\_region\_for\_deploy](#output\_aws\_region\_for\_deploy) | The AWS region where the module is deployed. |
<!-- END_TF_DOCS -->
