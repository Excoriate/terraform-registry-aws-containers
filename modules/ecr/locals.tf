locals {
  aws_region_to_deploy = var.aws_region

  is_ecr_enabled              = var.is_enabled && var.ecr_config != null
  is_lifecycle_policy_enabled = !local.is_ecr_enabled ? false : var.ecr_lifecycle_policy_config != null

  ecr_config_normalised = !local.is_ecr_enabled ? [] : [for ecr_config in var.ecr_config : {
    name                     = lower(trimspace(ecr_config.name))
    scan_on_push             = ecr_config["scan_on_push"] == null ? true : ecr_config["scan_on_push"]
    image_tag_mutability     = ecr_config["image_tag_mutability"] == null ? "MUTABLE" : upper(trimspace(ecr_config["image_tag_mutability"]))
    encryption_configuration = ecr_config["encryption_configuration"]
    force_delete            = ecr_config["force_delete"] == null ? false : ecr_config["force_delete"]
  }]

  // Create a list of maps, to make it suitable to the for_each
  ecr_config_to_create = !local.is_ecr_enabled ? {} : { for ecr in local.ecr_config_normalised : ecr["name"] => ecr }

  /*
    Notes:
     * This set of rules, are opinionated common lifecycle policies, for a quickstart use.
     * The lifecycle policy is applied to all ECR repositories.
  */
  untagged_image_rule = !local.is_lifecycle_policy_enabled ? [] : [{
    rulePriority = length(var.ecr_lifecycle_policy_config.protected_tags) + 1
    description  = "Remove untagged images"
    selection = {
      tagStatus   = "untagged"
      countType   = "imageCountMoreThan"
      countNumber = 1
    }
    action = {
      type = "expire"
    }
  }]

  remove_old_image_rule = !local.is_lifecycle_policy_enabled ? [] : [{
    rulePriority = length(var.ecr_lifecycle_policy_config.protected_tags) + 2
    description  = "Rotate images when reach ${var.ecr_lifecycle_policy_config.max_image_count} images stored",
    selection = {
      tagStatus   = "any"
      countType   = "imageCountMoreThan"
      countNumber = var.ecr_lifecycle_policy_config.max_image_count
    }
    action = {
      type = "expire"
    }
  }]

  protected_tag_rules = !local.is_lifecycle_policy_enabled ? [] : [
    for index, tagPrefix in zipmap(range(length(var.ecr_lifecycle_policy_config.protected_tags)), tolist(var.ecr_lifecycle_policy_config.protected_tags)) :
    {
      rulePriority = tonumber(index) + 1
      description  = "Protects images tagged with ${tagPrefix}"
      selection = {
        tagStatus     = "tagged"
        tagPrefixList = [tagPrefix]
        countType     = "imageCountMoreThan"
        countNumber   = 999999
      }
      action = {
        type = "expire"
      }
    }
  ]
}
