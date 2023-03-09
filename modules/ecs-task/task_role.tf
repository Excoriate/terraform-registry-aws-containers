resource "aws_iam_role" "this" {
  for_each             = { for k, v in local.task_config_to_create : k => v if v["is_default_task_role_to_be_created"] }
  name                 = format("%s-%s", each.value["name"], "task-exec-role")
  assume_role_policy   = join("", [for doc in [data.aws_iam_policy_document.ecs_task_role_assume_policy[each.key]] : doc.json])
  permissions_boundary = each.value["permissions_boundary"]
  tags                 = var.tags
}

data "aws_iam_policy_document" "ecs_task_role_assume_policy" {
  for_each = { for k, v in local.task_config_to_create : k => v if v["is_default_permissions_enabled"] }

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

/*
  * Specific set of default policies, that can be attached optionally to this ECS task.
  * 1. Default IAM policy, for common log/s3 operations.
*/

resource "aws_iam_policy" "ecs_task_iam_policy_default" {
  for_each = { for k, v in local.task_config_to_create : k => v if v["is_default_permissions_enabled"] }
  name     = format("%s-%s", each.value["name"], "ecs-task-pol-default")
  policy   = join("", [for doc in [data.aws_iam_policy_document.ecs_task_iam_policy_default_doc[each.key]] : doc.json])
}

data "aws_iam_policy_document" "ecs_task_iam_policy_default_doc" {
  for_each = { for k, v in local.task_config_to_create : k => v if v["is_default_permissions_enabled"] }

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "kms:Decrypt",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:DescribeTable",
      "dynamodb:ListTables",
      "dynamodb:DescribeTimeToLive"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_iam_policy_attachment_default" {
  for_each   = { for k, v in local.task_config_to_create : k => v if v["is_default_permissions_enabled"] }
  policy_arn = aws_iam_policy.ecs_task_iam_policy_default[each.key].arn
  role       = aws_iam_role.this[each.key].name
}

module "iam_policy_attacher" {
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
