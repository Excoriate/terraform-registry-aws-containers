module "main_module" {
  source     = "../../../../modules/auto-scaling/app-auto-scaling"
  is_enabled = var.is_enabled
  aws_region = var.aws_region

  auto_scaling_ecs_config = var.auto_scaling_ecs_config
}
