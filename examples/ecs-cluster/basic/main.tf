module "main_module" {
  source             = "../../../modules/ecs-cluster"
  is_enabled         = var.is_enabled
  aws_region         = var.aws_region
  ecs_cluster_config = var.ecs_cluster_config
}
