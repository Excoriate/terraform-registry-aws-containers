locals {
  aws_region_to_deploy = var.aws_region
  is_enabled           = !var.is_enabled ? false : var.task_config == null ? false : length(var.task_config) > 0 ? true : false

  /*
    * Task configuration:
     - It should receive a valid container definition.
     - The Family name is internally resolved.
     - The 'execution_role_arn' was named intentionally as 'ecs_role_arn' to avoid confusion with the 'task_role_arn'.
     - If the 'ecs_role_arn' isn't set, this module will create a new one.
  */
  task_config_normalized = !local.is_enabled ? [] : [
    for t in var.task_config : {
      name                           = lower(trimspace(t["name"]))
      family                         = t["family"] == null ? "ecs-task-${lower(trimspace(t["name"]))}" : t["family"]
      container_definition_from_json = t["container_definition_from_json"] == null ? "" : t["container_definition_from_json"]
      container_definition_from_file = t["container_definition_from_file"] == null ? "" : t["container_definition_from_file"]
      requires_compatibilities       = [t["type"]] // It defaults to 'Fargate' if not set.
      network_mode                   = t["network_mode"] == null ? "awsvpc" : t["network_mode"]
      cpu                            = t["cpu"] == null ? 256 : t["cpu"]
      memory                         = t["memory"] == null ? 512 : t["memory"]
      // Task role ARN
      task_role_arn         = t["task_role_arn"] == null ? null : trimspace(t["task_role_arn"])
      permissions_boundary  = t["permissions_boundary"] == null ? null : trimspace(t["permissions_boundary"])
      extra_iam_policy_arns = t["enable_extra_iam_policies_arn"]

      // feature flags
      is_default_task_role_to_be_created        = t["task_role_arn"] == null
      is_default_permissions_enabled            = t["enable_default_permissions"]
      is_container_definition_from_file_enabled = t["container_definition_from_file"] != null && t["container_definition_from_json"] == null
      is_extra_iam_policy_arns_enabled          = t["enable_extra_iam_policies_arn"] == null ? [] : length(t["enable_extra_iam_policies_arn"]) > 0 ? true : false
    }
  ]

  task_config_to_create = !local.is_enabled ? {} : {
    for t in local.task_config_normalized : t["name"] => {
      name                           = t["name"]
      family                         = t["family"]
      container_definition_from_json = t["container_definition_from_json"]
      container_definition_from_file = t["container_definition_from_file"]
      requires_compatibilities       = t["requires_compatibilities"]
      network_mode                   = t["network_mode"]
      cpu                            = t["cpu"]
      memory                         = t["memory"]
      // Permissions.
      task_role_arn         = t["task_role_arn"]
      permissions_boundary  = t["permissions_boundary"]
      extra_iam_policy_arns = t["extra_iam_policy_arns"]

      // Feature flags.
      is_default_task_role_to_be_created        = t["is_default_task_role_to_be_created"]
      is_container_definition_from_file_enabled = t["is_container_definition_from_file_enabled"]
      is_default_permissions_enabled            = t["is_default_permissions_enabled"]
      is_extra_iam_policy_arns_enabled          = t["is_extra_iam_policy_arns_enabled"]
    }
  }
}
