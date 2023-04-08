locals {
  aws_region_to_deploy    = var.aws_region
  is_enabled              = !var.is_enabled ? false : var.task_config == null ? false : length(var.task_config) > 0 ? true : false
  is_task_permissions_set = !local.is_enabled ? false : var.task_permissions_config == null ? false : length(var.task_permissions_config) > 0

  /*
    * Task configuration:
     - It should receive a valid container definition.
     - The Family name is internally resolved.
     - The 'execution_role_arn' was named intentionally as 'ecs_role_arn' to avoid confusion with the 'task_role_arn'.
     - If the 'ecs_role_arn' isn't set, this module will create a new one.
  */
  task_config_normalized = !local.is_enabled ? [] : [
    for t in var.task_config : {
      name                             = lower(trimspace(t["name"]))
      family                           = t["family"] == null ? "ecs-task-${lower(trimspace(t["name"]))}" : t["family"]
      container_definition_from_json   = t["container_definition_from_json"] == null ? "" : t["container_definition_from_json"]
      container_definition_from_file   = t["container_definition_from_file"] == null ? "" : t["container_definition_from_file"]
      requires_compatibilities         = [t["type"]] // It defaults to 'Fargate' if not set.
      network_mode                     = t["network_mode"] == null ? "awsvpc" : t["network_mode"]
      cpu                              = t["cpu"] == null ? 256 : t["cpu"]
      memory                           = t["memory"] == null ? 512 : t["memory"]
      manage_task_outside_of_terraform = t["manage_task_outside_of_terraform"] == null ? false : t["manage_task_outside_of_terraform"]

      proxy_configuration = t["proxy_configuration"] == null ? {} : {
        type           = t["proxy_configuration"]["type"] == null ? "APPMESH" : t["proxy_configuration"]["type"]
        container_name = t["proxy_configuration"]["container_name"] == null ? "envoy" : t["proxy_configuration"]["container_name"]
        properties = t["proxy_configuration"]["properties"] == null ? [] : [
          for p in t["proxy_configuration"]["properties"] : {
            name  = p["name"]
            value = p["value"]
          }
        ]
      }

      ephemeral_storage = t["ephemeral_storage"] == null ? {} : {
        size_in_gib = t["ephemeral_storage"]
      }

      task_placement_constraints = t["task_placement_constraints"] == null ? [] : [
        for c in t["task_placement_constraints"] : {
          type       = trimspace(c["type"])
          expression = trimspace(c["expression"])
        }
      ]

      service_placement_constraints = t["service_placement_constraints"] == null ? [] : [
        for c in t["service_placement_constraints"] : {
          type       = trimspace(c["type"])
          expression = trimspace(c["expression"])
        }
      ]

      runtime_platform = t["runtime_platforms"] == null ? [] : [
        for p in t["runtime_platforms"] : trimspace(p)
      ]

      // feature flags
      is_container_definition_from_file_enabled = t["container_definition_from_file"] != null && t["container_definition_from_json"] == null
      is_runtime_platforms_option_enabled       = t["runtime_platforms"] == null ? false : length(t["runtime_platforms"]) > 0
      /*
         - As soon as the task_permissions_config variable is set, it'll require the user to pass the 'task_role_arn' and 'execution_role_arn' for each task.
         - If the 'name' is present, it's set. Therefore, the built-in roles won't be created
      */
      is_task_role_passed_by_user = length([for permissions in local.task_permissions_set_by_user_normalised : permissions if permissions["name"] == t["name"]]) == 0 ? false : true
      #      is_task_role_passed_by_user      = length([for permissions in local.task_permissions_set_by_user_normalised : permissions if permissions["name"] == t["name"] && permissions["task_role_arn"] != null]) == 0 ? false : true
      is_execution_role_passed_by_user = length([for permissions in local.task_permissions_set_by_user_normalised : permissions if permissions["name"] == t["name"]]) == 0 ? false : true
      #      is_execution_role_passed_by_user = length([for permissions in local.task_permissions_set_by_user_normalised : permissions if permissions["name"] == t["name"] && permissions["execution_role_arn"] != null]) == 0 ? false : true
      disable_built_in_permissions = length([for permissions in local.task_permissions_set_by_user_normalised : permissions if permissions["name"] == t["name"] && permissions["disable_built_in_permissions"]]) == 0 ? false : true
    }
  ]

  task_config_create = !local.is_enabled ? {} : {
    for t in local.task_config_normalized : t["name"] => t
  }

  /*
    * Task permissions configuration:
     - These permissions are passed by the user.
     - They are just normalised, and passed to the main ecs task resource.
  */
  task_permissions_set_by_user_normalised = !local.is_task_permissions_set ? [] : [
    for task_permission in var.task_permissions_config : {
      name                         = lower(trimspace(task_permission.name))
      task_role_arn                = task_permission["task_role_arn"] == null ? null : trimspace(task_permission["task_role_arn"])
      execution_role_arn           = task_permission["execution_role_arn"] == null ? null : trimspace(task_permission["execution_role_arn"])
      permissions_boundary         = task_permission["permissions_boundary"] == null ? null : trimspace(task_permission["permissions_boundary"])
      disable_built_in_permissions = task_permission["disable_built_in_permissions"] == null ? false : task_permission["disable_built_in_permissions"]
    }
  ]

  task_permissions_set_by_user_create = !local.is_task_permissions_set ? {} : {
    for task_permission in local.task_permissions_set_by_user_normalised : task_permission["name"] => task_permission
  }

  /*
    * Task permissions configuration:
     - These permissions are resolved internally. If they aren't passed, they are created by this module.
     - A new ECS task role is going to be created.
     - A new ECS execution role is going to be created.
  */
  task_role_built_in_create_normalised = !local.is_enabled ? [] : [
    for task in local.task_config_normalized : {
      name   = trimspace(lower(task["name"]))
      create = task["disable_built_in_permissions"] == true ? false : lookup({ for k, v in local.task_permissions_set_by_user_create : k => v if v["name"] == task["name"] }, "task_role_arn", null) == null ? true : false
    }
  ]

  execution_role_built_in_create_normalised = !local.is_enabled ? [] : [
    for task in local.task_config_normalized : {
      name   = trimspace(lower(task["name"]))
      create = task["disable_built_in_permissions"] == true ? false : lookup({ for k, v in local.task_permissions_set_by_user_create : k => v if v["name"] == task["name"] }, "execution_role_arn", null) == null ? true : false
    }
  ]

  task_role_built_in_create = !local.is_enabled ? {} : {
    for permission in local.task_role_built_in_create_normalised : permission["name"] => permission if permission["create"]
  }

  execution_role_built_in_create = !local.is_enabled ? {} : {
    for permission in local.execution_role_built_in_create_normalised : permission["name"] => permission if permission["create"]
  }
}
