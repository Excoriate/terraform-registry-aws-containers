resource "aws_ecs_service" "this" {
  for_each                           = local.ecs_config_to_create
  name                               = each.value["name"]
  cluster                            = each.value["cluster"]
  task_definition                    = each.value["task_definition"]
  desired_count                      = each.value["desired_count"]
  deployment_maximum_percent         = each.value["deployment_maximum_percent"]
  deployment_minimum_healthy_percent = each.value["deployment_minimum_healthy_percent"]
  health_check_grace_period_seconds  = each.value["health_check_grace_period_seconds"]
  launch_type                        = each.value["launch_type"]
  platform_version                   = each.value["platform_version"]
  scheduling_strategy                = each.value["scheduling_strategy"]
  iam_role                           = each.value["is_ecs_execution_role_to_be_created"] && each.value["is_ecs_iam_role_to_be_merged"] ? coalesce(each.value["iam_role_to_attach"], aws_iam_role.this[each.key].arn) : each.value["is_ecs_execution_role_to_be_created"] ? aws_iam_role.this[each.key].arn : null
  wait_for_steady_state              = each.value["wait_for_steady_state"]
  force_new_deployment               = each.value["force_new_deployment"]
  enable_ecs_managed_tags            = each.value["enable_ecs_managed_tags"]
  tags                               = var.tags

  dynamic "load_balancer" {
    for_each = !each.value["is_load_balancers_enabled"] ? [] : each.value["load_balancer_config"]
    content {
      target_group_arn = load_balancer.value["target_group_arn"]
      container_name   = load_balancer.value["container_name"]
      container_port   = load_balancer.value["container_port"]
    }
  }

  dynamic "network_configuration" {
    for_each = !each.value["is_network_configuration_enabled"] ? {} : each.value["network_configuration"]
    content {
      subnets          = network_configuration.value["subnets"]
      security_groups  = network_configuration.value["security_groups"]
      assign_public_ip = network_configuration.value["assign_public_ip"]
    }
  }
}
