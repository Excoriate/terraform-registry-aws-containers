aws_region = "us-east-1"
is_enabled = true

auto_scaling_config = [
  {
    name         = "auto-scaling-identifier"
    dimension    = "DesireCount"
    resource_id  = "mycluster/my-service"
    min_capacity = 1
    max_capacity = 10
    type         = "ecs"
  },
  {
    name         = "auto-scaling-another"
    dimension    = "DesireCount"
    resource_id  = "mycluster/my-service"
    min_capacity = 2
    max_capacity = 10
    type         = "ecs"
  }
]

auto_scaling_ecs_config = [
  {
    // All the other are optionals, so it'll inherit the default values.
    name = "auto-scaling-identifier"
  },
  {
    name                = "auto-scaling-another"
    target_metric_value = 20
  }
]
