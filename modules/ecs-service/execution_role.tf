resource "aws_iam_role" "ecs_execution_role" {
  for_each             = { for k, v in local.task_config_to_create : k => v if v["is_execution_role_to_be_created"] }
  name                 = format("%s-%s", each.value["name"], "ecs-exec-role")
  assume_role_policy   = join("", data.aws_iam_policy_document.ecs_execution_role_assume_policy_doc.*.json)
  permissions_boundary = each.value["permissions_boundary"]
  tags                 = var.tags
}

resource "aws_iam_role_policy" "ecs_execution_policy" {
  for_each = { for k, v in local.task_config_to_create : k => v if v["is_execution_role_to_be_created"] }
  name     = format("%s-%s", each.value["name"], "ecs-exec-policy")
  policy   = join("", [for policy in data.aws_iam_policy_document.ecs_execution_policy_doc : policy.json])
  role     = join("", [for role in aws_iam_role.ecs_execution_role : role.id])
}

data "aws_iam_policy_document" "ecs_execution_role_assume_policy_doc" {
  count = length(keys({ for k, v in local.task_config_to_create : k => v if v["is_execution_role_to_be_created"] }) > 0 ? 1 : 0)

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_execution_policy_doc" {
  count = length(keys({ for k, v in local.task_config_to_create : k => v if v["is_execution_role_to_be_created"] }) > 0 ? 1 : 0)

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
