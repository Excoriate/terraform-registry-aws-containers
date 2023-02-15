resource "aws_appautoscaling_target" "ecs_target" {
  for_each           = local.auto_scaling_target_ecs_to_create
  service_namespace  = each.value["service_namespace"]
  resource_id        = each.value["resource_id"]
  scalable_dimension = each.value["scalable_dimension"]
  min_capacity       = each.value["min_capacity"]
  max_capacity       = each.value["max_capacity"]
  role_arn           = each.value["role_arn"]
}

resource "aws_appautoscaling_policy" "ecs_scale_up" {
  for_each           = local.auto_scaling_policy_ecs_to_create
  name               = format("scaling-up-%s-%s", each.value["name"], "up")
  service_namespace  = "ecs"
  resource_id        = each.value["resource_id"]
  scalable_dimension = each.value["scalable_dimension"]

  step_scaling_policy_configuration {
    adjustment_type         = each.value["adjustment_type"]
    cooldown                = each.value["scale_up_cool_down"]
    metric_aggregation_type = each.value["metric_aggregation_type"]

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = each.value["scale_up_adjustment"]
    }
  }
}

resource "aws_appautoscaling_policy" "ecs_scale_down" {
  for_each           = local.auto_scaling_policy_ecs_to_create
  name               = format("scaling-down-%s-%s", each.value["name"], "down")
  service_namespace  = "ecs"
  resource_id        = each.value["resource_id"]
  scalable_dimension = each.value["scalable_dimension"]

  step_scaling_policy_configuration {
    adjustment_type         = each.value["adjustment_type"]
    cooldown                = each.value["scale_down_cool_down"]
    metric_aggregation_type = each.value["metric_aggregation_type"]

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = each.value["scale_down_adjustment"]
    }
  }
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  for_each           = local.auto_scaling_policy_ecs_to_create
  name               = format("default-tracking-cpu-%s", each.value["name"])
  policy_type        = "TargetTrackingScaling"
  resource_id        = each.value["resource_id"]
  scalable_dimension = each.value["scalable_dimension"]
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    target_value = each.value["target_metric_value"]
    predefined_metric_specification {
      predefined_metric_type = each.value["target_metric_type"]
    }
  }
}
