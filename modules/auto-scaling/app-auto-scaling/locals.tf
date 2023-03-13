locals {
  aws_region_to_deploy = var.aws_region
  is_ecs_enabled       = !var.is_enabled ? false : var.auto_scaling_ecs_config == null ? false : length(var.auto_scaling_ecs_config) > 0


  /*
   * Target auto-scaling configuration.
   * It's currently only supported the ECS type of target. TODO: Add more supported targets in the future.
  */
  auto_scaling_target_normalized = !local.is_ecs_enabled ? [] : [
    for ac in var.auto_scaling_ecs_config : {
      name              = trimspace(ac["name"])
      resource_id       = format("service/%s/%s", lower(trimspace(ac["cluster_name"])), lower(trimspace(ac["service_name"])))
      dimension         = format("ecs:service:%s", trimspace(ac["dimension"]))
      service_namespace = "ecs"
      type              = "ecs"
      min_capacity      = ac["min_capacity"]
      max_capacity      = ac["max_capacity"]
      adjustment_type   = ac["adjustment_type"]
      role_arn          = ac["role_arn"] == null ? null : trimspace(ac["role_arn"])
      policy_type       = ac["policy_type"]
      metrics = {
        type        = ac["target_metric_type"]
        value       = ac["target_metric_value"]
        policy_type = ac["target_metric_policy_type"]
      }
      scale_up = {
        cool_down               = ac["scale_up_cool_down"]
        adjustment              = ac["scale_up_adjustment"]
        metric_aggregation_type = ac["scale_up_metric_aggregation_type"]
      }
      scale_down = {
        cool_down               = ac["scale_down_cool_down"]
        adjustment              = ac["scale_down_adjustment"]
        metric_aggregation_type = ac["scale_down_metric_aggregation_type"]
      }
    }
  ]

  auto_scaling_target_ecs_create = !local.is_ecs_enabled ? {} : {
    for ac in local.auto_scaling_target_normalized : ac["name"] => ac
  }

}
