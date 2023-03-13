locals {
  redeployment_trigger = {
    redeployment = timestamp()
  }
}

resource "aws_ecs_service" "this" {
  for_each                           = { for k, v in local.ecs_config_create : k => v if v["is_task_definition_changes_ignored_enabled"] == false && v["is_desired_count_changes_ignored_enabled"] == false }
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
  iam_role                           = !each.value["create_built_in_permissions"] ? null : each.value["is_network_awsvpc_enabled"] ? null : lookup({ for k, v in local.ecs_permissions_create : k => v if v["name"] == each.value["name"] }, "iam_role_arn", join("", [for role in aws_iam_role.this : role.arn]))
  wait_for_steady_state              = each.value["wait_for_steady_state"]
  force_new_deployment               = each.value["force_new_deployment"]
  enable_ecs_managed_tags            = each.value["enable_ecs_managed_tags"]
  tags                               = var.tags
  propagate_tags                     = each.value["propagate_tags"]

  dynamic "load_balancer" {
    for_each = !each.value["is_load_balancers_enabled"] ? {} : { for k, v in each.value["load_balancers_config"] : k => v }

    content {
      target_group_arn = load_balancer.value["target_group_arn"]
      container_name   = load_balancer.value["container_name"]
      container_port   = load_balancer.value["container_port"]
    }
  }

  dynamic "network_configuration" {
    for_each = !each.value["is_network_configuration_enabled"] ? [] : [each.value["network_configuration"]]
    content {
      subnets          = network_configuration.value["subnets"]
      security_groups  = network_configuration.value["security_groups"]
      assign_public_ip = network_configuration.value["assign_public_ip"]
    }
  }

  dynamic "deployment_circuit_breaker" {
    for_each = !each.value["is_deployment_circuit_breaker_enabled"] ? [] : [each.value["deployment_circuit_breaker"]]
    content {
      enable   = true
      rollback = true
    }
  }

  triggers = each.value["is_deployment_on_apply_enabled"] ? local.redeployment_trigger : null
}

resource "aws_ecs_service" "ignore_task_definition_changes" {
  for_each                           = { for k, v in local.ecs_config_create : k => v if v["is_task_definition_changes_ignored_enabled"] == true && v["is_desired_count_changes_ignored_enabled"] == false }
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
  iam_role                           = !local.is_ecs_permission_enabled ? null : each.value["is_network_awsvpc_enabled"] ? null : lookup({ for k, v in local.ecs_permissions_create : k => v if v["name"] == each.value["name"] }, "iam_role_arn", join("", [for role in aws_iam_role.this : role.arn]))
  wait_for_steady_state              = each.value["wait_for_steady_state"]
  force_new_deployment               = each.value["force_new_deployment"]
  enable_ecs_managed_tags            = each.value["enable_ecs_managed_tags"]
  tags                               = var.tags
  propagate_tags                     = each.value["propagate_tags"]

  dynamic "load_balancer" {
    for_each = !each.value["is_load_balancers_enabled"] ? {} : { for k, v in each.value["load_balancers_config"] : k => v }
    content {
      target_group_arn = load_balancer.value["target_group_arn"]
      container_name   = load_balancer.value["container_name"]
      container_port   = load_balancer.value["container_port"]
    }
  }

  dynamic "network_configuration" {
    for_each = !each.value["is_network_configuration_enabled"] ? [] : [each.value["network_configuration"]]
    content {
      subnets          = network_configuration.value["subnets"]
      security_groups  = network_configuration.value["security_groups"]
      assign_public_ip = network_configuration.value["assign_public_ip"]
    }
  }

  dynamic "deployment_circuit_breaker" {
    for_each = !each.value["is_deployment_circuit_breaker_enabled"] ? [] : [each.value["deployment_circuit_breaker"]]
    content {
      enable   = true
      rollback = true
    }
  }

  triggers = each.value["is_deployment_on_apply_enabled"] ? local.redeployment_trigger : null

  lifecycle {
    ignore_changes = [
      task_definition,
    ]
  }
}

resource "aws_ecs_service" "ignore_desired_count_changes" {
  for_each                           = { for k, v in local.ecs_config_create : k => v if v["is_desired_count_changes_ignored_enabled"] == true && v["is_task_definition_changes_ignored_enabled"] == false }
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
  iam_role                           = !local.is_ecs_permission_enabled ? null : each.value["is_network_awsvpc_enabled"] ? null : lookup({ for k, v in local.ecs_permissions_create : k => v if v["name"] == each.value["name"] }, "iam_role_arn", join("", [for role in aws_iam_role.this : role.arn]))
  wait_for_steady_state              = each.value["wait_for_steady_state"]
  force_new_deployment               = each.value["force_new_deployment"]
  enable_ecs_managed_tags            = each.value["enable_ecs_managed_tags"]
  tags                               = var.tags
  propagate_tags                     = each.value["propagate_tags"]

  dynamic "load_balancer" {
    for_each = !each.value["is_load_balancers_enabled"] ? {} : { for k, v in each.value["load_balancers_config"] : k => v }

    content {
      target_group_arn = load_balancer.value["target_group_arn"]
      container_name   = load_balancer.value["container_name"]
      container_port   = load_balancer.value["container_port"]
    }
  }

  dynamic "network_configuration" {
    for_each = !each.value["is_network_configuration_enabled"] ? [] : [each.value["network_configuration"]]
    content {
      subnets          = network_configuration.value["subnets"]
      security_groups  = network_configuration.value["security_groups"]
      assign_public_ip = network_configuration.value["assign_public_ip"]
    }
  }

  dynamic "deployment_circuit_breaker" {
    for_each = !each.value["is_deployment_circuit_breaker_enabled"] ? [] : [each.value["deployment_circuit_breaker"]]
    content {
      enable   = true
      rollback = true
    }
  }

  triggers = each.value["is_deployment_on_apply_enabled"] ? local.redeployment_trigger : null

  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }
}

resource "aws_ecs_service" "ignore_desired_count_and_task_definition_changes" {
  for_each                           = { for k, v in local.ecs_config_create : k => v if v["is_desired_count_changes_ignored_enabled"] == true && v["is_task_definition_changes_ignored_enabled"] == true }
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
  iam_role                           = !local.is_ecs_permission_enabled ? null : each.value["is_network_awsvpc_enabled"] ? null : lookup({ for k, v in local.ecs_permissions_create : k => v if v["name"] == each.value["name"] }, "iam_role_arn", join("", [for role in aws_iam_role.this : role.arn]))
  wait_for_steady_state              = each.value["wait_for_steady_state"]
  force_new_deployment               = each.value["force_new_deployment"]
  enable_ecs_managed_tags            = each.value["enable_ecs_managed_tags"]
  tags                               = var.tags
  propagate_tags                     = each.value["propagate_tags"]

  dynamic "load_balancer" {
    for_each = !each.value["is_load_balancers_enabled"] ? {} : { for k, v in each.value["load_balancers_config"] : k => v }

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

  dynamic "deployment_circuit_breaker" {
    for_each = !each.value["is_deployment_circuit_breaker_enabled"] ? {} : each.value["deployment_circuit_breaker"]
    content {
      enable   = true
      rollback = true
    }
  }

  triggers = each.value["is_deployment_on_apply_enabled"] ? local.redeployment_trigger : null

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition
    ]
  }
}
