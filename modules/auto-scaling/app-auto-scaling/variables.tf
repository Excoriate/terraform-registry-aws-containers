variable "is_enabled" {
  type        = bool
  description = <<EOF
  Whether this module will be created or not. It is useful, for stack-composite
modules that conditionally includes resources provided by this module..
EOF
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy the resources"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources."
  default     = {}
}

/*
-------------------------------------
Custom input variables
-------------------------------------
*/

variable "auto_scaling_ecs_config" {
  type = list(object({
    name                               = string
    adjustment_type                    = optional(string, "ChangeInCapacity")
    dimension                          = optional(string, "DesiredCount")
    min_capacity                       = optional(number, 1)
    max_capacity                       = optional(number, 1)
    policy_type                        = optional(string, "StepScaling")
    cluster_name                       = string
    service_name                       = string
    scale_up_metric_aggregation_type   = optional(string, "Average")
    scale_up_cool_down                 = optional(number, 60)
    scale_up_adjustment                = optional(number, 1)
    scale_down_adjustment              = optional(number, -1)
    scale_down_metric_aggregation_type = optional(string, "Average")
    scale_down_cool_down               = optional(number, 60)
    target_metric_type                 = optional(string, "ECSServiceAverageCPUUtilization")
    target_metric_value                = optional(number, 50)
    target_metric_policy_type          = optional(string, "TargetTrackingScaling")
    role_arn                           = optional(string, null)
  }))
  description = <<EOF
  A list of objects that contains the configuration for the auto scaling group. This object
defines the auto-scaling strategy for an ECS service. The allowed attributes are:
- name: The name of the auto scaling group.
- adjustment_type: The adjustment type. Valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity.
- dimension: The dimension name. Valid values are DesiredCount, and InServiceCapacity.
- min_capacity: The minimum capacity.
- max_capacity: The maximum capacity.
- policy_type: The policy type. Valid values are StepScaling and TargetTrackingScaling.
- cluster_name: The name of the ECS cluster.
- service_name: The name of the ECS service.
- scale_up_metric_aggregation_type: The aggregation type for the CloudWatch metrics. Valid values are Minimum, Maximum, and Average.
- scale_up_cool_down: The amount of time, in seconds, after a scaling activity completes before any further trigger-related scaling activities can start.
- scale_up_adjustment: The number of instances by which to scale. AdjustmentType determines the interpretation of this number (e.g., as an absolute number or as a percentage of the existing Auto Scaling group size). A positive value adds to the current capacity and a negative number removes from the current capacity.
- scale_down_adjustment: The number of instances by which to scale. AdjustmentType determines the interpretation of this number (e.g., as an absolute number or as a percentage of the existing Auto Scaling group size). A positive value adds to the current capacity and a negative number removes from the current capacity.
- scale_down_metric_aggregation_type: The aggregation type for the CloudWatch metrics. Valid values are Minimum, Maximum, and Average.
- scale_down_cool_down: The amount of time, in seconds, after a scaling activity completes before any further trigger-related scaling activities can start.
- target_metric_type: The metric type. Valid values are ECSServiceAverageCPUUtilization, ECSServiceAverageMemoryUtilization, ALBRequestCountPerTarget, and DynamoDBReadCapacityUtilization.
- target_metric_value: The target value for the metric.
- target_metric_policy_type: The policy type. Valid values are StepScaling and TargetTrackingScaling.
- role_arn: The ARN of the IAM role that allows Amazon EC2 Auto Scaling to publish to the CloudWatch metrics.
EOF
  default     = null
}
