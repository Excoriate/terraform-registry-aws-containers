/*
  * Task role
  ==================================
  1. Out of the box execution role
  ==================================
*/
resource "aws_iam_role" "task_role" {
  for_each           = local.task_role_built_in_create
  name               = format("%s-%s", each.value["name"], "task-exec-role")
  assume_role_policy = join("", [for doc in [data.aws_iam_policy_document.task_role_policy[each.key]] : doc.json])
  tags               = var.tags
}

data "aws_iam_policy_document" "task_role_policy" {
  for_each = local.task_role_built_in_create

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_role_policy_fargate_doc" {
  for_each = local.task_role_built_in_create

  statement {
    sid    = "taskpolfargate1"
    effect = "Allow"
    actions = [
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets",
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "kms:Decrypt",
      "sns:Publish",
      "sns:ListTopics",
      "sns:ListSubscriptionsByTopic",
      "sns:ListSubscriptions",
      "sns:ListSubscriptionsByTopic",
      "sns:ListTopicsByPlatformApplication",
      "sns:GetTopicAttributes",
      "sns:GetSubscriptionAttributes",
      "sns:GetPlatformApplicationAttributes",
      "sns:CreateTopic",
      "sns:Subscribe",
      "sns:ConfirmSubscription",
      "sns:Unsubscribe",
      "sns:SetTopicAttributes",
      "sns:SetSubscriptionAttributes",
      "sqs:SendMessage",
      "sqs:SendMessageBatch",
      "sqs:ReceiveMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ListQueues",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [
      "*"
    ]
  }
}


resource "aws_iam_policy" "task_role_policy_fargate" {
  for_each = local.task_role_built_in_create

  name   = format("%s-%s", each.value["name"], "task-exec-policy")
  policy = join("", [for doc in [data.aws_iam_policy_document.task_role_policy_fargate_doc[each.key]] : doc.json])
}

resource "aws_iam_role_policy_attachment" "task_role_policy_fargate_attachment" {
  for_each = local.task_role_built_in_create

  role       = aws_iam_role.task_role[each.key].id
  policy_arn = join("", [for pol_arn in [aws_iam_policy.task_role_policy_fargate[each.key]] : pol_arn.arn])
}
