resource "aws_ecs_task_definition" "this" {
  for_each                 = local.task_config_create
  family                   = each.value["family"]
  requires_compatibilities = each.value["requires_compatibilities"]
  container_definitions    = each.value["is_container_definition_from_file_enabled"] ? file(each.value["container_definition_from_file"]) : each.value["container_definition_from_json"] == null ? "" : each.value["container_definition_from_json"]
  cpu                      = each.value["cpu"]
  memory                   = each.value["memory"]
  network_mode             = each.value["network_mode"]
  execution_role_arn       = local.is_task_permissions_set ? lookup({ for k, v in local.task_permissions_set_by_user_create : k => v["execution_role_arn"] if v["name"] == each.key }) : aws_iam_role.this[each.key].arn
  task_role_arn            = local.is_task_permissions_set ? lookup({ for k, v in local.task_permissions_set_by_user_create : k => v["task_role_arn"] if v["name"] == each.key }) : aws_iam_role.this[each.key].arn

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
}
