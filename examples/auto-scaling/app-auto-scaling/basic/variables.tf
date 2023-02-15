variable "is_enabled" {
  description = "Enable or disable the module"
  type        = bool
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "auto_scaling_config" {
  type = list(object({
    name         = string
    type         = string
    resource_id  = string
    dimension    = string
    min_capacity = optional(number, 1)
    max_capacity = optional(number, 1)
    role_arn     = optional(string, null)
  }))
  description = <<EOF
A configuration object, that defines an auto-scaling configuration for an application in AWS. This object doesn't
define the auto-scaling specifics configuration. For such configurations, please refer to the input variable
'var.auto_scaling_ecs_config' or the one that corresponds to the specific AWS application (DynamoDB, Aurora, ECS, etc.)
The current attributes that are supported are:
- name: Unique identifier for this auto-scaling configuration.
- type: The type of the auto-scaling configuration. E.g.: ecs, dynamodb, aurora.
- resource_id: Unique identifier for this auto-scaling configuration.
- dimension: The dimension of the auto-scaling configuration.
- min_capacity: The minimum capacity of the auto-scaling configuration.
- max_capacity: The maximum capacity of the auto-scaling configuration.
- role_arn: The ARN of the IAM role that allows Application Auto Scaling to modify your scalable target on your behalf.
EOF
  default     = null
}

variable "auto_scaling_ecs_config" {
  type = list(object({
    name                    = string
    adjustment_type         = optional(string, "ChangeInCapacity")
    metric_aggregation_type = optional(string, "Average")
    scale_up_cool_down      = optional(number, 60)
    scale_down_cool_down    = optional(number, 60)
    scale_up_adjustment     = optional(number, 1)
    scale_down_adjustment   = optional(number, -1)
    target_metric_type      = optional(string, "ECSServiceAverageCPUUtilization")
    target_metric_value     = optional(number, 50)
  }))
  description = <<EOF
A configuration object, that defines an auto-scaling configuration for an application in AWS. This
  configuration is used to configure the auto-scaling for an application in AWS.
Current attributes supported:
- name: Unique identifier for this auto-scaling configuration.
- adjustment_type: The adjustment type, which specifies how ScalingAdjustment is interpreted. Valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity.
- metric_aggregation_type: The aggregation type for the CloudWatch metrics. Valid values are Minimum, Maximum, and Average.
- scale_up_cool_down: The amount of time, in seconds, after a scale in activity completes before another scale in activity can start.
- scale_down_cool_down: The amount of time, in seconds, after a scale out activity completes before another scale out activity can start.
- scale_up_adjustment: The amount by which to scale, based on the specified adjustment type. A positive value adds to the current capacity while a negative number removes from the current capacity.
- scale_down_adjustment: The amount by which to scale, based on the specified adjustment type. A positive value adds to the current capacity while a negative number removes from the current capacity.
- target_metric_type: The metric type. The only valid value is ECSServiceAverageCPUUtilization.
- target_metric_value: The target value for the metric.
EOF
  default     = null
}
