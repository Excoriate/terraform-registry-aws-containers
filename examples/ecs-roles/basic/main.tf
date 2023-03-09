module "main_module" {
  source     = "../../../modules/ecs-roles"
  is_enabled = var.is_enabled
  aws_region = var.aws_region

  execution_role_ooo_config         = var.execution_role_ooo_config
  execution_role_config             = var.execution_role_config
  execution_role_permissions_config = var.execution_role_permissions_config
  task_role_ooo_config              = var.task_role_ooo_config
  task_role_config                  = var.task_role_config
  task_role_permissions_config      = var.task_role_permissions_config
}
