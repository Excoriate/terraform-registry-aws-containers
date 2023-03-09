aws_region = "us-east-1"
is_enabled = true

task_role_ooo_config = [
  {
    name = "test"
    enable_ooo_role_common  = true
    enable_ooo_role_fargate = false
  }
]
