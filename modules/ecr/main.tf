resource "aws_ecr_repository" "this" {
  for_each             = local.ecr_config_to_create
  name                 = each.value["name"]
  image_tag_mutability = each.value["image_tag_mutability"]

  dynamic "encryption_configuration" {
    for_each = each.value["encryption_configuration"] == null ? [] : [each.value["encryption_configuration"]]
    content {
      encryption_type = encryption_configuration.value["encryption_type"]
      kms_key         = encryption_configuration.value["kms_key"]
    }
  }

  image_scanning_configuration {
    scan_on_push = each.value["scan_on_push"]
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "name" {
  for_each = !local.is_lifecycle_policy_enabled ? {} : local.ecr_config_to_create
  #  repository = aws_ecr_repository.name[each.value].name
  repository = [for k, v in aws_ecr_repository.this : v.name if v.name == each.value["name"]][0]

  policy = jsonencode({
    rules = concat(local.protected_tag_rules, local.untagged_image_rule, local.remove_old_image_rule)
  })
}
