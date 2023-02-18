resource "aws_ecs_task_definition" "this" {
  for_each                 = local.task_config_to_create
  family                   = each.value["family"]
  requires_compatibilities = each.value["requires_compatibilities"]
  container_definitions    = each.value["is_container_definition_from_file_enabled"] ? file(each.value["container_definition_from_file"]) : each.value["container_definition_from_json"]
  cpu                      = each.value["cpu"]
  memory                   = each.value["memory"]
  network_mode             = each.value["network_mode"]
  task_role_arn            = each.value["is_default_task_role_to_be_created"] ? join("", [for r in aws_iam_role.this : r.arn]) : each.value["task_role_task_role_arn"]

  tags = var.tags
}
