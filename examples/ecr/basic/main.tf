module "main_module" {
  source                      = "../../../modules/ecr"
  is_enabled                  = var.is_enabled
  aws_region                  = var.aws_region
  ecr_config                  = var.ecr_config
  ecr_lifecycle_policy_config = var.ecr_lifecycle_policy_config
}
