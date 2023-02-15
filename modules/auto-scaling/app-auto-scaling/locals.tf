locals {
  aws_region_to_deploy = var.aws_region
  is_enabled           = !var.is_enabled ? false : var.auto_scaling_config == null ? false : length(var.auto_scaling_config) > 0 ? true : false

  /*
   * Target auto-scaling configuration.
   * It's currently only supported the ECS type of target. TODO: Add more supported targets in the future.
  */
  auto_scaling_target_normalized = !local.is_enabled ? [] : [
    for ac in var.auto_scaling_config : {
      name         = trimspace(ac["name"])
      type         = trimspace(ac["type"]) // Identify the app-autoscaling type.
      resource_id  = ac["resource_id"] == null ? null : trimspace(ac["resource_id"])
      dimension    = trimspace(ac["dimension"])
      min_capacity = ac["min_capacity"]
      max_capacity = ac["max_capacity"]
      role_arn     = ac["role_arn"] == null ? null : trimspace(ac["role_arn"])
    }
  ]

  auto_scaling_target_ecs = !local.is_enabled ? [] : [
    for ac in local.auto_scaling_target_normalized : ac if ac["type"] == "ecs"
  ]

  auto_scaling_target_ecs_normalized = !local.is_enabled ? [] : [
    for ac in local.auto_scaling_target_ecs : {
      name               = ac["name"]
      service_namespace  = "ecs"
      resource_id        = format("service/%s", trimspace(ac["resource_id"]))
      scalable_dimension = format("ecs:service:%s", trimspace(ac["dimension"]))
      min_capacity       = ac["min_capacity"]
      max_capacity       = ac["max_capacity"]
      role_arn           = ac["role_arn"]
    }
  ]

  auto_scaling_target_ecs_to_create = !local.is_enabled ? {} : {
    for ac in local.auto_scaling_target_ecs_normalized : ac["name"] => ac
  }

  /*
   * Target auto-scaling policy.
   * It's currently only supported the ECS type of target. TODO: Add more supported targets in the future.
  */

  is_ecs_autoscaling_policy_enabled = !local.is_enabled ? false : var.auto_scaling_ecs_config == null ? false : length(var.auto_scaling_ecs_config) > 0 ? true : false

  auto_scaling_policy_ecs_normalized = !local.is_ecs_autoscaling_policy_enabled ? [] : [
    for ac in var.auto_scaling_ecs_config : {
      name                    = trimspace(ac["name"])
      adjustment_type         = ac["adjustment_type"] == null ? "ChangeInCapacity" : trimspace(ac["adjustment_type"])
      metric_aggregation_type = ac["metric_aggregation_type"] == null ? "Average" : trimspace(ac["metric_aggregation_type"])
      scale_up_cool_down      = ac["scale_up_cool_down"] == null ? 60 : ac["scale_up_cool_down"]
      scale_down_cool_down    = ac["scale_down_cool_down"] == null ? 60 : ac["scale_down_cool_down"]
      scale_up_adjustment     = ac["scale_up_adjustment"] == null ? 1 : ac["scale_up_adjustment"]
      scale_down_adjustment   = ac["scale_down_adjustment"] == null ? -1 : ac["scale_down_adjustment"]
      target_metric_type      = ac["target_metric_type"] == null ? "ECSServiceAverageCPUUtilization" : trimspace(ac["target_metric_type"])
      target_metric_value     = ac["target_metric_value"] == null ? 50 : ac["target_metric_value"]
    }
  ]

  // Create a map, merging the auto-scaling target and auto-scaling policy based on the 'name' attribute.
  auto_scaling_policy_ecs_to_create = !local.is_ecs_autoscaling_policy_enabled ? {} : {
    for ac in local.auto_scaling_policy_ecs_normalized : ac["name"] => merge(
      local.auto_scaling_target_ecs_to_create[ac["name"]],
      {
        adjustment_type         = ac["adjustment_type"]
        metric_aggregation_type = ac["metric_aggregation_type"]
        scale_up_cool_down      = ac["scale_up_cool_down"]
        scale_down_cool_down    = ac["scale_down_cool_down"]
        scale_up_adjustment     = ac["scale_up_adjustment"]
        scale_down_adjustment   = ac["scale_down_adjustment"]
        target_metric_type      = ac["target_metric_type"]
        target_metric_value     = ac["target_metric_value"]
      }
    )
  }
}
