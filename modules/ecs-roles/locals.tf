locals {
  aws_region_to_deploy = var.aws_region
  is_enabled           = var.is_enabled

  /*
    * Specific control flags:
      - is_enabled: if false, the module will not be deployed.
      - is_execution_role_enabled : if true, the module will create an execution role for the out of office lambda.
      -is_execution_role_ooo_enabled : if true, the module will create an execution role for the out of office lambda.
  */
  is_execution_role_ooo_enabled             = !local.is_enabled ? false : var.execution_role_ooo_config == null ? false : length(var.execution_role_ooo_config) > 0
  is_execution_role_custom_enabled          = !local.is_enabled ? false : var.execution_role_config == null ? false : length(var.execution_role_config) > 0
  is_execution_role_custom_policies_enabled = !local.is_execution_role_custom_enabled ? false : var.execution_role_permissions_config == null ? false : length(var.execution_role_permissions_config) > 0
  is_task_role_ooo_enabled                  = !local.is_enabled ? false : var.task_role_ooo_config == null ? false : length(var.task_role_ooo_config) > 0
  is_task_role_custom_enabled               = !local.is_enabled ? false : var.task_role_config == null ? false : length(var.task_role_config) > 0
  is_task_role_custom_policies_enabled      = !local.is_task_role_custom_enabled ? false : var.task_role_permissions_config == null ? false : length(var.task_role_permissions_config) > 0

  exec_role_ooo_normalised = !local.is_execution_role_ooo_enabled ? [] : [
    for role in var.execution_role_ooo_config : {
      name                    = trimspace(lower(role.name))
      role_name               = role["role_name"] == null ? trimspace(lower(role.name)) : trimspace(lower(role["role_name"]))
      description             = format("Role for %s", trimspace(lower(role.name)))
      permissions_boundary    = role["permissions_boundary"] == null ? null : trimspace(lower(role["permissions_boundary"]))
      enable_ooo_role_common  = role["enable_ooo_role_common"] == null ? false : role["enable_ooo_role_common"]
      enable_ooo_role_fargate = role["enable_ooo_role_fargate"] == null ? false : role["enable_ooo_role_fargate"]
    }
  ]

  exec_role_ooo_create = !local.is_execution_role_ooo_enabled ? {} : {
    for role in local.exec_role_ooo_normalised : role["name"] => role
  }

  exec_role_custom_normalised = !local.is_execution_role_custom_enabled ? [] : [
    for role in var.execution_role_config : {
      name                 = trimspace(lower(role.name))
      role_name            = role["role_name"] == null ? trimspace(lower(role.name)) : trimspace(lower(role["role_name"]))
      description          = format("Custom Execution Role for %s", trimspace(lower(role.name)))
      permissions_boundary = role["permissions_boundary"] == null ? null : trimspace(lower(role["permissions_boundary"]))
    }
  ]

  exec_role_custom_create = !local.is_execution_role_custom_enabled ? {} : {
    for role in local.exec_role_custom_normalised : role["name"] => role
  }

  exec_role_policies_custom_normalised = !local.is_execution_role_custom_policies_enabled ? [] : [
    for p in var.execution_role_permissions_config : {
      policy_name = trimspace(lower(p.policy_name))
      role_name   = trimspace(lower(p.role_name))
      policy_config = {
        name        = trimspace(lower(p.policy_name))
        description = format("Custom Policy for %s", trimspace(lower(p.policy_name)))
        statements = [{
          sid       = replace(replace(format("sidpol%s", trimspace(lower(p.policy_name))), "-", ""), "_", "")
          effect    = p["type"] == null ? "Deny" : p["type"],
          actions   = p["merge_with_default_permissions"] == false ? p["actions"] : concat(p["actions"], local.iam_policy_execution_role_custom_policy_default_allow["statements"][0]["actions"])
          resources = p["resources"] == null ? ["*"] : p["resources"]
        }]
      }
    }
  ]

  exec_role_policies_custom_create = !local.is_execution_role_custom_policies_enabled ? {} : {
    for p in local.exec_role_policies_custom_normalised : p["policy_name"] => p
  }

  task_role_ooo_normalised = !local.is_task_role_ooo_enabled ? [] : [
    for role in var.task_role_ooo_config : {
      name                    = trimspace(lower(role.name))
      role_name               = role["role_name"] == null ? trimspace(lower(role.name)) : trimspace(lower(role["role_name"]))
      description             = format("Custom Task Role for %s", trimspace(lower(role.name)))
      permissions_boundary    = role["permissions_boundary"] == null ? null : trimspace(lower(role["permissions_boundary"]))
      enable_ooo_role_common  = role["enable_ooo_role_common"] == null ? false : role["enable_ooo_role_common"]
      enable_ooo_role_fargate = role["enable_ooo_role_fargate"] == null ? false : role["enable_ooo_role_fargate"]
    }
  ]

  task_role_ooo_create = !local.is_task_role_ooo_enabled ? {} : {
    for role in local.task_role_ooo_normalised : role["name"] => role
  }

  task_role_custom_normalised = !local.is_task_role_custom_enabled ? [] : [
    for role in var.task_role_config : {
      name                 = trimspace(lower(role.name))
      role_name            = role["role_name"] == null ? trimspace(lower(role.name)) : trimspace(lower(role["role_name"]))
      description          = format("Custom Task Role for %s", trimspace(lower(role.name)))
      permissions_boundary = role["permissions_boundary"] == null ? null : trimspace(lower(role["permissions_boundary"]))
    }
  ]

  task_role_custom_create = !local.is_task_role_custom_enabled ? {} : {
    for role in local.task_role_custom_normalised : role["name"] => role
  }

  task_role_policies_custom_normalised = !local.is_task_role_custom_policies_enabled ? [] : [
    for p in var.task_role_permissions_config : {
      policy_name = trimspace(lower(p.policy_name))
      role_name   = trimspace(lower(p.role_name))
      policy_config = {
        name        = trimspace(lower(p.policy_name))
        description = format("Custom Policy for %s", trimspace(lower(p.policy_name)))
        statements = [{
          sid       = replace(replace(format("sidpol%s", trimspace(lower(p.policy_name))), "-", ""), "_", "")
          effect    = p["type"] == null ? "Deny" : p["type"],
          actions   = p["merge_with_default_permissions"] == false ? p["actions"] : concat(p["actions"], local.iam_policy_task_role_custom_policy_default_allow["statements"][0]["actions"])
          resources = p["resources"] == null ? ["*"] : p["resources"]
        }]
      }
    }
  ]

  task_role_policies_custom_create = !local.is_task_role_custom_policies_enabled ? {} : {
    for p in local.task_role_policies_custom_normalised : p["policy_name"] => p
  }

  /*
    * Common IAM policies for the task roles
      - Common IAM policy.
      - Common IAM policy for Fargate launch-related deployments.
  */
  iam_policy_task_role_ooo = {
    statements = [
      {
        sid    = "taskrolecommon"
        effect = "Allow"
        resources = [
          "*"
        ]
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
    ]
  }

  iam_policy_task_role_ooo_fargate = {
    statements = [
      {
        sid    = "taskrolecommon"
        effect = "Allow"
        resources = [
          "*"
        ]
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
          "dynamodb:DescribeTimeToLive",
          "ecs:ListTasks",
          "ecs:DescribeTasks",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeContainerInstances",
          "ecs:DescribeServices",
          "rds-data:ExecuteStatement",
          "rds-data:BatchExecuteStatement",
          "rds-data:BeginTransaction",
          "rds-data:CommitTransaction",
          "rds-data:RollbackTransaction",
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
          "sqs:DeleteMessage",
          "sqs:DeleteMessageBatch",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ListQueues",
          "sqs:ChangeMessageVisibility",
        ]
      }
    ]
  }

  /*
    * Common IAM policies for the execution role
      - Common IAM policy.
      - Common IAM policy for Fargate launch-related deployments.
  */
  iam_policy_execution_role_ooo = {
    statements = [
      {
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
        ]
        resources = [
          "*"
        ]
      }
    ]
  }

  iam_policy_execution_role_fargate_ooo = {
    statements = [
      {
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
    ]
  }

  iam_policy_execution_role_custom_policy_default_allow = {
    statements = [
      {
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
      }
    ]
  }

  iam_policy_task_role_custom_policy_default_allow = {
    statements = [
      {
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
          // crud in dynamodb
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DescribeTable",
          "dynamodb:ListTables",
          "dynamodb:DescribeTimeToLive",
          // crud in rds
          "rds-data:ExecuteStatement",
          "rds-data:Query",
          "rds-data:BatchExecuteStatement",
          "rds-data:BeginTransaction",
          "rds-data:CommitTransaction",
          "rds-data:RollbackTransaction",
          // crud in ecs
          "ecs:ListTasks",
          "ecs:DescribeTasks",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeContainerInstances",
          "ecs:DescribeServices",
          // crud in sns
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
          // crud in sqs
          "sqs:SendMessage",
          "sqs:SendMessageBatch",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:DeleteMessageBatch",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ListQueues",
          // bucket operations
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ]
      }
    ]
  }

}
