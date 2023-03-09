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
    policy_name                    = "pol1"
    role_name                      = "test"
    merge_with_default_permissions = true
    actions                        = ["*"]
    type                           = "Deny"
  }
]
