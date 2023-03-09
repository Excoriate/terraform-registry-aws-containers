/*
  * Task role
  ==================================
  1. Out of the box execution role
  ==================================
*/
resource "aws_iam_role" "task_role_ooo" {
  for_each             = local.task_role_ooo_create
  name                 = format("%s-%s", each.value["name"], "task-exec-role")
  assume_role_policy   = join("", [for doc in [data.aws_iam_policy_document.task_role_ooo_assume_role[each.key]] : doc.json])
  permissions_boundary = each.value["permissions_boundary"]
  tags                 = var.tags
}

data "aws_iam_policy_document" "task_role_ooo_assume_role" {
  for_each = local.task_role_ooo_create

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

module "iam_policy_task_role_ooo_common" {
  for_each   = { for k, v in local.task_role_ooo_create : k => v if v["enable_ooo_role_common"] }
  source     = "git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy?ref=v0.49.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  iam_policy_config = [
    merge({
      name = each.value["name"]
      tags = var.tags
    }, local.iam_policy_task_role_ooo)
  ]
}

module "iam_policy_task_role_ooo_common_attachment" {
  for_each   = { for k, v in local.task_role_ooo_create : k => v if v["enable_ooo_role_common"] }
  source     = "git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy-attacher?ref=v0.49.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  config = [
    {
      name       = each.value["name"]
      role       = aws_iam_role.task_role_ooo[each.key].name
      policy_arn = join("", [for doc in module.iam_policy_task_role_ooo_common[each.key].iam_policy_arn : doc])
    }
  ]
}

module "iam_policy_task_role_ooo_fargate" {
  for_each   = { for k, v in local.task_role_ooo_create : k => v if v["enable_ooo_role_fargate"] }
  source     = "git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy?ref=v0.49.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  iam_policy_config = [
    merge({
      name = each.value["name"]
      tags = var.tags
    }, local.iam_policy_task_role_ooo_fargate)
  ]
}

module "iam_policy_task_role_ooo_fargate_attachment" {
  for_each   = { for k, v in local.task_role_ooo_create : k => v if v["enable_ooo_role_fargate"] }
  source     = "git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy-attacher?ref=v0.49.0"
  aws_region = var.aws_region
  is_enabled = var.is_enabled

  config = [
    {
      name       = each.value["name"]
      role       = aws_iam_role.task_role_ooo[each.key].name
      policy_arn = join("", [for doc in module.iam_policy_task_role_ooo_fargate[each.key].iam_policy_arn : doc])
    }
  ]
}

/*
  * Task role
  ==================================
  . Custom execution role (with custom policies)
  ==================================
*/
resource "aws_iam_role" "task_role_custom" {
  for_each             = local.task_role_custom_create
  name                 = format("%s-%s", each.value["name"], "task-exec-role")
  assume_role_policy   = join("", [for doc in [data.aws_iam_policy_document.task_role_custom_assume_role[each.key]] : doc.json])
  permissions_boundary = each.value["permissions_boundary"]
  tags                 = var.tags
}

data "aws_iam_policy_document" "task_role_custom_assume_role" {
  for_each = local.task_role_custom_create

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

module "iam_policy_task_role_custom" {
  for_each = { for k, v in local.task_role_policies_custom_create : k => v["policy_config"] }
  source   = "git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy?ref=v0.49.0"

  aws_region = var.aws_region
  is_enabled = var.is_enabled

  iam_policy_config = [each.value]
  tags              = var.tags
}

module "iam_policy_task_role_custom_attachment" {
  for_each = { for k, v in local.task_role_policies_custom_create : k => v }
  source   = "git::github.com/Excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy-attacher?ref=v0.49.0"

  aws_region = var.aws_region
  is_enabled = var.is_enabled

  config = [
    {
      name       = each.value["policy_name"]
      role       = aws_iam_role.task_role_custom[each.value["role_name"]].name
      policy_arn = join("", [for doc in module.iam_policy_task_role_custom[each.value["policy_name"]].iam_policy_arn : doc])
    }
  ]
}
