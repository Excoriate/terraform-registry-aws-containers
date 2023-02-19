resource "aws_ecs_task_definition" "this" {
  for_each                 = local.task_config_to_create
  family                   = each.value["family"]
  requires_compatibilities = each.value["requires_compatibilities"]
  container_definitions    = each.value["is_container_definition_from_file_enabled"] ? file(each.value["container_definition_from_file"]) : each.value["container_definition_from_json"] == null ? "" : each.value["container_definition_from_json"]
  cpu                      = each.value["cpu"]
  memory                   = each.value["memory"]
  network_mode             = each.value["network_mode"]
  task_role_arn            = each.value["is_default_task_role_to_be_created"] ? join("", [for r in aws_iam_role.this : r.arn]) : each.value["task_role_arn"]

  tags = var.tags

  lifecycle {
    precondition {
      condition     = !each.value["is_container_definition_from_file_enabled"] && each.value["task_role_arn"] == null
      error_message = "Both the container_definition_from_file and container_definition_from_json are empty or aren't set. Please provide at least one of them."
    }
  }

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
}
