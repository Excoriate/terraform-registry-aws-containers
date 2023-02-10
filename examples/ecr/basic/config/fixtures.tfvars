aws_region = "us-east-1"
is_enabled = true

ecr_config = [
  {
    name                 = "my-ecr-repo"
    image_tag_mutability = "IMMUTABLE"
  }
]
