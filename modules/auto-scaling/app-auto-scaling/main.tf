resource "aws_appautoscaling_target" "this" {
  for_each           = local.auto_scaling_target_ecs_create
  service_namespace  = each.value["service_namespace"]
  resource_id        = each.value["resource_id"]
  scalable_dimension = each.value["dimension"]
  min_capacity       = each.value["min_capacity"]
  max_capacity       = each.value["max_capacity"]
  role_arn           = each.value["role_arn"]
}

resource "aws_appautoscaling_policy" "ecs_scale_up" {
  for_each           = local.auto_scaling_target_ecs_create
  name               = format("scaling-up-%s-%s", each.value["name"], "up")
  service_namespace  = each.value["service_namespace"]
  resource_id        = each.value["resource_id"]
  scalable_dimension = each.value["dimension"]
  policy_type        = each.value["policy_type"]

  step_scaling_policy_configuration {
    adjustment_type         = each.value["adjustment_type"]
    cooldown                = lookup(each.value["scale_up"], "cool_down")
    metric_aggregation_type = lookup(each.value["scale_up"], "metric_aggregation_type")

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = lookup(each.value["scale_up"], "adjustment")
    }
  }
}

resource "aws_appautoscaling_policy" "ecs_scale_down" {
  for_each           = local.auto_scaling_target_ecs_create
  name               = format("scaling-down-%s-%s", each.value["name"], "down")
  service_namespace  = "ecs"
  resource_id        = each.value["resource_id"]
  scalable_dimension = each.value["dimension"]
  policy_type        = each.value["policy_type"]

  step_scaling_policy_configuration {
    adjustment_type         = each.value["adjustment_type"]
    cooldown                = lookup(each.value["scale_down"], "cool_down")
    metric_aggregation_type = lookup(each.value["scale_down"], "metric_aggregation_type")

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = lookup(each.value["scale_down"], "adjustment")
    }
  }
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  for_each           = local.auto_scaling_target_ecs_create
  name               = format("default-tracking-cpu-%s", each.value["name"])
  policy_type        = lookup(each.value["metrics"], "policy_type", "TargetTrackingScaling")
  resource_id        = each.value["resource_id"]
  scalable_dimension = each.value["dimension"]
  service_namespace  = each.value["service_namespace"]

  target_tracking_scaling_policy_configuration {
    target_value = lookup(each.value["metrics"], "value", 50)
    predefined_metric_specification {
      predefined_metric_type = lookup(each.value["metrics"], "type", "ECSServiceAverageCPUUtilization")
    }
  }
}
