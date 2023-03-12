locals {
  aws_region_to_deploy = var.aws_region
  is_enabled           = !var.is_enabled ? false : var.ecs_service_config == null ? false : length(var.ecs_service_config) > 0 ? true : false
  // It defines whether to create a custom IAM role based on inputs, or stick with the built-in default one.
  is_ecs_permission_enabled = !local.is_enabled ? false : var.ecs_service_permissions_config == null ? false : length(var.ecs_service_permissions_config) > 0 ? true : false

  /*
    * ECS service configuration:
  */
  ecs_config_normalised = !local.is_enabled ? [] : [
    for t in var.ecs_service_config : {
      name            = lower(trimspace(t["name"]))
      task_definition = t["task_definition"]
      network_configuration = t["network_config"] == null ? null : {
        mode             = t["network_mode"]["mode"] == null ? "awsvpc" : lower(trimspace(t["network_mode"]["mode"]))
        subnets          = t["network_mode"]["subnets"] == null ? [] : t["network_mode"]["subnets"]
        security_groups  = t["network_mode"]["security_groups"] == null ? [] : t["network_mode"]["security_groups"]
        assign_public_ip = t["network_mode"]["assign_public_ip"] == null ? false : t["network_mode"]["assign_public_ip"]
      }
      desired_count                      = t["desired_count"] == null ? 1 : t["desired_count"]
      deployment_maximum_percent         = t["deployment_maximum_percent"] == null ? 200 : t["deployment_maximum_percent"]
      deployment_minimum_healthy_percent = t["deployment_minimum_healthy_percent"] == null ? 100 : t["deployment_minimum_healthy_percent"]
      health_check_grace_period_seconds  = t["health_check_grace_period_seconds"] == null ? null : t["health_check_grace_period_seconds"]
      launch_type                        = t["launch_type"] == null ? "FARGATE" : upper(trimspace(t["launch_type"]))
      platform_version                   = t["platform_version"] == null ? "LATEST" : lower(trimspace(t["platform_version"]))
      scheduling_strategy                = t["scheduling_strategy"] == null ? "REPLICA" : upper(trimspace(t["scheduling_strategy"]))
      enable_ecs_managed_tags            = t["enable_ecs_managed_tags"] == null ? false : t["enable_ecs_managed_tags"]
      wait_for_steady_state              = t["wait_for_steady_state"] == null ? true : t["wait_for_steady_state"]
      force_new_deployment               = t["force_new_deployment"] == null ? false : t["force_new_deployment"]
      enable_execute_command             = t["enable_execute_command"] == null ? false : t["enable_execute_command"]
      cluster                            = t["cluster"]
      propagate_tags                     = t["propagate_tags"] == null ? "TASK_DEFINITION" : upper(trimspace(t["propagate_tags"]))
      enable_deployment_circuit_breaker  = t["enable_deployment_circuit_breaker"] == null ? false : t["enable_deployment_circuit_breaker"]
      load_balancer_config = t["load_balancers_config"] == null ? null : [
        for l in t["load_balancers_config"] : {
          target_group_arn = lower(trimspace(l["target_group_arn"]))
          container_name   = lower(trimspace(l["container_name"]))
          container_port   = l["container_port"]
        }
      ]

      // feature flags.
      is_load_balancers_enabled             = t["load_balancers_config"] == null ? false : length(t["load_balancers_config"]) > 0 ? true : false
      is_network_configuration_enabled      = t["network_config"] == null ? false : true
      is_network_awsvpc_enabled             = t["network_config"] == null ? false : t["network_config"]["mode"] == null ? false : lower(trimspace(t["network_config"]["mode"])) == "awsvpc" ? true : false
      is_deployment_circuit_breaker_enabled = t["enable_deployment_circuit_breaker"] == null ? false : t["enable_deployment_circuit_breaker"] ? true : false
      is_deployment_on_apply_enabled        = t["trigger_deploy_on_apply"] == null ? false : t["trigger_deploy_on_apply"]
      /*
        * The following feature flags are used to ignore changes on the ECS service task definition and desired count.
        * This is useful when you want to manage the task definition and desired count outside of Terraform.
        * For example, you can use the AWS CLI to update the task definition and desired count.
      */
      is_task_definition_changes_ignored_enabled = t["enable_ignore_changes_on_task_definition"] == null ? false : t["enable_ignore_changes_on_task_definition"]
      is_desired_count_changes_ignored_enabled   = t["enable_ignore_changes_on_desired_count"] == null ? false : t["enable_ignore_changes_on_desired_count"]
    }
  ]

  ecs_config_create = !local.is_enabled ? {} : {
    for t in local.ecs_config_normalised : t["name"] => t
  }

  /*
    * ECS service permissions configuration:
  */

  ecs_permissions_normalised = !local.is_ecs_permission_enabled ? [] : [
    for ecs_permission in var.ecs_service_permissions_config : {
      name                 = lower(trimspace(ecs_permission["name"]))
      execution_role_arn   = ecs_permission["execution_role_arn"] == null ? null : lower(trimspace(ecs_permission["execution_role_arn"]))
      iam_role_arn         = ecs_permission["iam_role_arn"] == null ? null : lower(trimspace(ecs_permission["iam_role_arn"]))
      permissions_boundary = ecs_permission["permissions_boundary"] == null ? null : lower(trimspace(ecs_permission["permissions_boundary"]))

      // feature flags.
      create_execution_role_enabled = ecs_permission["execution_role_arn"] == null ? false : true
    }
  ]

  ecs_permissions_create = !local.is_ecs_permission_enabled ? {} : {
    for p in local.ecs_permissions_normalised : p["name"] => p
  }
}
