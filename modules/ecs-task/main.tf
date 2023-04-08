resource "aws_ecs_task_definition" "tg_unmanaged_default" {
  for_each                 = { for k, v in local.task_config_create : k => v if v["manage_task_outside_of_terraform"] && v["is_task_role_passed_by_user"] == true && v["is_execution_role_passed_by_user"] == true }
  family                   = each.value["family"]
  requires_compatibilities = each.value["requires_compatibilities"]
  container_definitions    = each.value["is_container_definition_from_file_enabled"] ? file(each.value["container_definition_from_file"]) : each.value["container_definition_from_json"] == null ? "" : each.value["container_definition_from_json"]
  cpu                      = each.value["cpu"]
  memory                   = each.value["memory"]
  network_mode             = each.value["network_mode"]
  execution_role_arn       = lookup(lookup({ for k, v in local.task_permissions_set_by_user_create : k => v if k == each.key }, each.key), "execution_role_arn")
  task_role_arn            = lookup(lookup({ for k, v in local.task_permissions_set_by_user_create : k => v if k == each.key }, each.key), "task_role_arn")

  tags = var.tags

  dynamic "proxy_configuration" {
    for_each = each.value["proxy_configuration"]
    content {
      type           = proxy_configuration.value["type"]
      container_name = proxy_configuration.value["container_name"]
      properties     = proxy_configuration.value["properties"]
    }
  }

  dynamic "ephemeral_storage" {
    for_each = each.value["ephemeral_storage"]
    content {
      size_in_gib = ephemeral_storage.value["size_in_gib"]
    }
  }

  dynamic "placement_constraints" {
    for_each = each.value["task_placement_constraints"]
    content {
      type       = placement_constraints.value["type"]
      expression = placement_constraints.value["expression"]
    }
  }

  dynamic "runtime_platform" {
    for_each = each.value["runtime_platform"]
    content {
      operating_system_family = runtime_platform.value["operating_system_family"]
      cpu_architecture        = runtime_platform.value["cpu_architecture"]
    }
  }

  lifecycle {
    ignore_changes = [
      container_definitions
    ]
  }
}

resource "aws_ecs_task_definition" "tf_unmanaged_built_in_permissions" {
  for_each                 = { for k, v in local.task_config_create : k => v if v["manage_task_outside_of_terraform"] && v["is_task_role_passed_by_user"] == false && v["is_execution_role_passed_by_user"] == false }
  family                   = each.value["family"]
  requires_compatibilities = each.value["requires_compatibilities"]
  container_definitions    = each.value["is_container_definition_from_file_enabled"] ? file(each.value["container_definition_from_file"]) : each.value["container_definition_from_json"] == null ? "" : each.value["container_definition_from_json"]
  cpu                      = each.value["cpu"]
  memory                   = each.value["memory"]
  network_mode             = each.value["network_mode"]
  execution_role_arn       = each.value["disable_built_in_permissions"] ? null : aws_iam_role.execution_role[each.key].arn
  task_role_arn            = each.value["disable_built_in_permissions"] ? null : aws_iam_role.execution_role[each.key].arn

  tags = var.tags

  dynamic "proxy_configuration" {
    for_each = each.value["proxy_configuration"]
    content {
      type           = proxy_configuration.value["type"]
      container_name = proxy_configuration.value["container_name"]
      properties     = proxy_configuration.value["properties"]
    }
  }

  dynamic "ephemeral_storage" {
    for_each = each.value["ephemeral_storage"]
    content {
      size_in_gib = ephemeral_storage.value["size_in_gib"]
    }
  }

  dynamic "placement_constraints" {
    for_each = each.value["task_placement_constraints"]
    content {
      type       = placement_constraints.value["type"]
      expression = placement_constraints.value["expression"]
    }
  }

  dynamic "runtime_platform" {
    for_each = each.value["runtime_platform"]
    content {
      operating_system_family = runtime_platform.value["operating_system_family"]
      cpu_architecture        = runtime_platform.value["cpu_architecture"]
    }
  }
}



resource "aws_ecs_task_definition" "default" {
  for_each                 = { for k, v in local.task_config_create : k => v if !v["manage_task_outside_of_terraform"] && v["is_task_role_passed_by_user"] == true && v["is_execution_role_passed_by_user"] == true }
  family                   = each.value["family"]
  requires_compatibilities = each.value["requires_compatibilities"]
  container_definitions    = each.value["is_container_definition_from_file_enabled"] ? file(each.value["container_definition_from_file"]) : each.value["container_definition_from_json"] == null ? "" : each.value["container_definition_from_json"]
  cpu                      = each.value["cpu"]
  memory                   = each.value["memory"]
  network_mode             = each.value["network_mode"]
  execution_role_arn       = lookup(lookup({ for k, v in local.task_permissions_set_by_user_create : k => v if k == each.key }, each.key), "execution_role_arn")
  task_role_arn            = lookup(lookup({ for k, v in local.task_permissions_set_by_user_create : k => v if k == each.key }, each.key), "task_role_arn")

  tags = var.tags

  dynamic "proxy_configuration" {
    for_each = each.value["proxy_configuration"]
    content {
      type           = proxy_configuration.value["type"]
      container_name = proxy_configuration.value["container_name"]
      properties     = proxy_configuration.value["properties"]
    }
  }

  dynamic "ephemeral_storage" {
    for_each = each.value["ephemeral_storage"]
    content {
      size_in_gib = ephemeral_storage.value["size_in_gib"]
    }
  }

  dynamic "placement_constraints" {
    for_each = each.value["task_placement_constraints"]
    content {
      type       = placement_constraints.value["type"]
      expression = placement_constraints.value["expression"]
    }
  }

  dynamic "runtime_platform" {
    for_each = each.value["runtime_platform"]
    content {
      operating_system_family = runtime_platform.value["operating_system_family"]
      cpu_architecture        = runtime_platform.value["cpu_architecture"]
    }
  }
}

resource "aws_ecs_task_definition" "default_built_in_permissions" {
  for_each                 = { for k, v in local.task_config_create : k => v if !v["manage_task_outside_of_terraform"] && v["is_task_role_passed_by_user"] == false && v["is_execution_role_passed_by_user"] == false }
  family                   = each.value["family"]
  requires_compatibilities = each.value["requires_compatibilities"]
  container_definitions    = each.value["is_container_definition_from_file_enabled"] ? file(each.value["container_definition_from_file"]) : each.value["container_definition_from_json"] == null ? "" : each.value["container_definition_from_json"]
  cpu                      = each.value["cpu"]
  memory                   = each.value["memory"]
  network_mode             = each.value["network_mode"]
  execution_role_arn       = each.value["disable_built_in_permissions"] ? null : aws_iam_role.execution_role[each.key].arn
  task_role_arn            = each.value["disable_built_in_permissions"] ? null : aws_iam_role.execution_role[each.key].arn

  tags = var.tags

  dynamic "proxy_configuration" {
    for_each = each.value["proxy_configuration"]
    content {
      type           = proxy_configuration.value["type"]
      container_name = proxy_configuration.value["container_name"]
      properties     = proxy_configuration.value["properties"]
    }
  }

  dynamic "ephemeral_storage" {
    for_each = each.value["ephemeral_storage"]
    content {
      size_in_gib = ephemeral_storage.value["size_in_gib"]
    }
  }

  dynamic "placement_constraints" {
    for_each = each.value["task_placement_constraints"]
    content {
      type       = placement_constraints.value["type"]
      expression = placement_constraints.value["expression"]
    }
  }

  dynamic "runtime_platform" {
    for_each = each.value["runtime_platform"]
    content {
      operating_system_family = runtime_platform.value["operating_system_family"]
      cpu_architecture        = runtime_platform.value["cpu_architecture"]
    }
  }
}
