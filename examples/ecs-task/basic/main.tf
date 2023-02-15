module "main_module" {
  source     = "../../../modules/ecs-task"
  is_enabled = var.is_enabled
  aws_region = var.aws_region
}
