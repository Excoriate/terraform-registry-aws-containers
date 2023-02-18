resource "aws_ecs_task_definition" "this" {
  for_each                 = local.task_config_to_create
  family                   = each.value["family"]
  requires_compatibilities = each.value["requires_compatibilities"]
  container_definitions    = each.value["is_container_definition_from_file_enabled"] ? file(each.value["container_definition_from_file"]) : each.value["container_definition_from_json"]
  cpu                      = each.value["cpu"]
  memory                   = each.value["memory"]
  network_mode             = each.value["network_mode"]
  execution_role_arn       = each.value["is_execution_role_to_be_created"] ? join("", aws_iam_role.ecs_execution_role[each.key].arn) : each.value["execution_role_arn"]
  #  task_role_arn      = length(var.task_role_arn) > 0 ? var.task_role_arn : join("", aws_iam_role.ecs_task.*.arn)

  tags = var.tags
}
