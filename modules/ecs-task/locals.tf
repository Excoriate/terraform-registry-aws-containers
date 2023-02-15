locals {
  aws_region_to_deploy = var.aws_region
  is_enabled           = !var.is_enabled ? false : var.auto_scaling_config == null ? false : length(var.auto_scaling_config) > 0 ? true : false
}
