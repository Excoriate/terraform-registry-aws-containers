locals {
  aws_region_to_deploy = var.aws_region

  /*
      * ECS Cluster configuration. Set separately the ECS cluster, and the capacity provider.
  */
  is_cluster_enabled = !var.is_enabled ? false : var.ecs_cluster_config == null ? false : length(var.ecs_cluster_config) > 0 ? true : false
  #  is_cluster_configuration_enabled = !var.is_enabled ? false : var.ecs_cluster_config == null ? false : length([for ecs in var.ecs_cluster_config : ecs if ecs["cluster_configuration"] != null]) > 0 ? true : false

  ecs_cluster_normalised = !var.is_enabled ? [] : var.ecs_cluster_config == null ? [] : [
    for ecs in var.ecs_cluster_config : {
      name               = lower(trimspace(ecs.name))
      container_insights = ecs["enable_container_insights"] == null ? "disabled" : "enabled"
    }
  ]

  ecs_cluster_to_create = !local.is_cluster_enabled ? {} : { for ecs in local.ecs_cluster_normalised : ecs["name"] => ecs }

  /*
      * ECS Capacity provider configuration.
  */

  is_cluster_capacity_provider_enabled = !local.is_cluster_enabled ? false : var.ecs_cluster_config == null ? false : length([for ecs in var.ecs_cluster_config : ecs if ecs["providers"] != null]) > 0 ? true : false

  ecs_capacity_providers_normalised = !local.is_cluster_capacity_provider_enabled ? [] : [
    for ecs in var.ecs_cluster_config : {
      cluster_name       = lower(trimspace(ecs.name))
      capacity_providers = [ecs["providers"] == null ? "FARGATE_SPOT" : lookup(ecs["providers"], "type", "FARGATE_SPOT")]
      default_capacity_provider_strategy = ecs["providers"] != null ? [
        {
          capacity_provider = lookup(ecs["providers"], "type", "FARGATE_SPOT")
          weight            = lookup(ecs["providers"], "weight", 1)
          base              = lookup(ecs["providers"], "base", 0)
        }
        ] : [
        {
          capacity_provider = "FARGATE_SPOT"
          weight            = 1
          base              = 0
        }
      ]
    }
  ]

  ecs_capacity_providers_to_create = !local.is_cluster_capacity_provider_enabled ? {} : { for provider in local.ecs_capacity_providers_normalised : provider["cluster_name"] => provider if provider["capacity_providers"] != null }
}
