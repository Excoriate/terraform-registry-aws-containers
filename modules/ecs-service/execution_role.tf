resource "aws_iam_role" "this" {
  for_each             = { for k, v in local.ecs_config_to_create : k => v if v["is_ecs_execution_role_to_be_created"] }
  name                 = format("%s-%s", each.value["name"], "ecs-exec-role")
  assume_role_policy   = join("", [for doc in [data.aws_iam_policy_document.ecs_execution_role_assume_policy[each.key]] : doc.json])
  permissions_boundary = each.value["permissions_boundary"]
  tags                 = var.tags
}

data "aws_iam_policy_document" "ecs_execution_role_assume_policy" {
  for_each = { for k, v in local.ecs_config_to_create : k => v if v["is_ecs_execution_role_to_be_created"] }

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}


resource "aws_iam_policy" "ecs_service_iam_policy_default" {
  for_each = { for k, v in local.ecs_config_to_create : k => v if v["is_ecs_execution_role_to_be_created"] }
  name     = format("%s-%s", each.value["name"], "ecs-svc-pol-default")
  policy   = join("", [for doc in [data.aws_iam_policy_document.ecs_service_iam_policy_default_doc[each.key]] : doc.json])
}

data "aws_iam_policy_document" "ecs_service_iam_policy_default_doc" {
  for_each = { for k, v in local.ecs_config_to_create : k => v if v["is_ecs_execution_role_to_be_created"] }

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "ecs_service_iam_policy_attachment_default" {
  for_each   = { for k, v in local.ecs_config_to_create : k => v if v["is_ecs_execution_role_to_be_created"] }
  policy_arn = aws_iam_policy.ecs_service_iam_policy_default[each.key].arn
  role       = aws_iam_role.this[each.key].name
}

module "iam_policy_attachments" {
  count      = local.is_extra_iam_policies_enabled ? 1 : 0
  source     = "git::github.com/excoriate/terraform-registry-aws-accounts-creator//modules/iam-policy-attacher"
  aws_region = var.aws_region
  is_enabled = local.is_extra_iam_policies_enabled

  config = [for attachment in local.extra_iam_policies : {
    name       = attachment["task_name"]
    role       = attachment["role_name"] == "USER-DEFAULT" ? aws_iam_role.this[attachment["task_name"]].name : attachment["role_name"]
    policy_arn = attachment["policy_arn"]
  }]
}
