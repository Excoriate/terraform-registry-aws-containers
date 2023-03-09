aws_region = "us-east-1"
is_enabled = true

execution_role_config = [
  {
    name = "test"
  }
]

execution_role_permissions_config = [
  {
    resources                      = ["*"]
    policy_name                    = "pol2"
    role_name                      = "test"
    merge_with_default_permissions = false
    actions                        = ["ec2:Describe*", "ec2:CreateTags"]
    type                           = "Allow"
  }
]
