aws_region = "us-east-1"
is_enabled = true

ecr_config = [
  {
    name                 = "my-ecr-repo-lifecycle"
    image_tag_mutability = "IMMUTABLE"
  }
]

ecr_lifecycle_policy_config = {
  max_image_count = 300
  protected_tags  = ["latest", "prod", "dev", "staging"]
}
