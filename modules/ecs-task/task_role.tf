#module "ecs_task_role" {
#  for_each = {for k, v in local.task_config_to_create: k => v if v["is_default_task_role_to_be_created"]}
#  source   = "../ecs-roles"
#  aws_region = var.aws_region
#  is_enabled = var.is_enabled && each.value["is_default_task_role_to_be_created"]
#
#  task_role_ooo_config = [
#    {
#      name                    = each.value["name"]
#      role_name               = each.value["name"]
#      enable_ooo_role_common  = true
#    }
#  ]
#}
