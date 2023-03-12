/*
  * Execution role
  ==================================
  1. Out of the box execution role
  ==================================
*/
resource "aws_iam_role" "this" {
  for_each           = local.execution_role_built_in_create
  name               = format("%s-%s", each.value["name"], "ecs-exec-role")
  assume_role_policy = join("", [for doc in [data.aws_iam_policy_document.this[each.key]] : doc.json])
  tags               = var.tags
}

data "aws_iam_policy_document" "this" {
  for_each = local.execution_role_built_in_create

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "fargate_policy" {
  for_each = local.execution_role_built_in_create

  statement {
    sid    = "oooexeccommon"
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
    ]
    resources = [
      "*"
    ]
  }
}


resource "aws_iam_policy" "fargate" {
  for_each = local.execution_role_built_in_create

  name   = format("%s-%s", each.value["name"], "ecs-exec-policy")
  policy = join("", [for doc in [data.aws_iam_policy_document.fargate_policy[each.key]] : doc.json])
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = local.execution_role_built_in_create

  role       = aws_iam_role.this[each.key].id
  policy_arn = join("", [for pol_arn in [aws_iam_policy.fargate[each.key]] : pol_arn.arn])
}
