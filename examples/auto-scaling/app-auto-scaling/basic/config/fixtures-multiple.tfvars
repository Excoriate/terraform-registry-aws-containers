aws_region = "us-east-1"
is_enabled = true

auto_scaling_ecs_config = [
  {
    name         = "auto-scaling-identifier"
    min_capacity = 1
    max_capacity = 10
    cluster_name = "mycluster"
    service_name = "my-service"
  },
  {
    name         = "auto-scaling-identifier2"
    min_capacity = 1
    max_capacity = 2
    cluster_name = "mycluster2"
    service_name = "my-service2"
  }
]
