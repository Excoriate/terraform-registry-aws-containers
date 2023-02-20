locals {
  aws_region_to_deploy = var.aws_region
  is_enabled           = !var.is_enabled ? false : var.ecs_service_config == null ? false : length(var.ecs_service_config) > 0 ? true : false

  /*
    * ECS service configuration:
  */
  ecs_config_normalized = !local.is_enabled ? [] : [
    for t in var.ecs_service_config : {
      name            = lower(trimspace(t["name"]))
      task_definition = lower(trimspace(t["task_definition_arn"]))
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
      permissions_boundary               = t["permissions_boundary"] == null ? null : lower(trimspace(t["permissions_boundary"]))
      ecs_execution_role                 = t["ecs_execution_role"] == null ? null : lower(trimspace(t["ecs_execution_role"]))
      ecs_iam_role                       = t["ecs_iam_role"] == null ? null : lower(trimspace(t["ecs_iam_role"]))
      load_balancer_config = t["load_balancers_config"] == null ? null : [
        for l in t["load_balancers_config"] : {
          target_group_arn = lower(trimspace(l["target_group_arn"]))
          container_name   = lower(trimspace(l["container_name"]))
          container_port   = l["container_port"]
        }
      ]

      // feature flags.
      is_ecs_execution_role_to_be_created = t["ecs_execution_role"] == null
      is_ecs_iam_role_to_be_merged        = t["ecs_iam_role"] != null && t["ecs_execution_role"] != null
      is_load_balancers_enabled           = t["load_balancers_config"] == null ? false : length(t["load_balancers_config"]) > 0 ? true : false
      is_network_configuration_enabled    = t["network_config"] == null ? false : true
    }
  ]

  ecs_config_to_create = !local.is_enabled ? {} : {
    for t in local.ecs_config_normalized : t["name"] => {
      name                               = t["name"]
      task_definition                    = t["task_definition"]
      network_configuration              = t["network_configuration"]
      desired_count                      = t["desired_count"]
      deployment_maximum_percent         = t["deployment_maximum_percent"]
      deployment_minimum_healthy_percent = t["deployment_minimum_healthy_percent"]
      health_check_grace_period_seconds  = t["health_check_grace_period_seconds"]
      launch_type                        = t["launch_type"]
      platform_version                   = t["platform_version"]
      scheduling_strategy                = t["scheduling_strategy"]
      enable_ecs_managed_tags            = t["enable_ecs_managed_tags"]
      wait_for_steady_state              = t["wait_for_steady_state"]
      force_new_deployment               = t["force_new_deployment"]
      enable_execute_command             = t["enable_execute_command"]
      cluster                            = t["cluster"]
      permissions_boundary               = t["permissions_boundary"]
      load_balancer_config               = t["load_balancer_config"]
      iam_role                           = t["ecs_execution_role"]
      iam_role_to_attach                 = t["ecs_iam_role"]
      network_configuration              = t["network_configuration"]

      // feature flags.
      is_ecs_execution_role_to_be_created = t["is_ecs_execution_role_to_be_created"]
      is_ecs_iam_role_to_be_merged        = t["is_ecs_iam_role_to_be_merged"]
      is_load_balancers_enabled           = t["is_load_balancers_enabled"]
      is_network_configuration_enabled    = t["is_network_configuration_enabled"]
    }
  }

  is_extra_iam_policies_enabled = !local.is_enabled ? false : var.ecs_extra_iam_policies == null ? false : length(var.ecs_extra_iam_policies) > 0
  extra_iam_policies = !local.is_extra_iam_policies_enabled ? [] : [
    for p in var.ecs_extra_iam_policies : {
      ecs_service = lower(trimspace(p["ecs_service"]))
      policy_arn  = trimspace(p["policy_arn"])
      role_name   = p["role_name"] == null ? "USER-DEFAULT" : trimspace(p["role_name"])
    }
  ]
}
