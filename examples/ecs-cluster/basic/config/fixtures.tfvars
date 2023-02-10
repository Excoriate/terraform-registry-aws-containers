aws_region = "us-east-1"
is_enabled = true

ecs_cluster_config = [
  {
    name = "cluster-test"
  },
  {
    name                      = "cluster-test-2"
    enable_container_insights = true
  }
]
