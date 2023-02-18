module "main_module" {
  source     = "../../../modules/ecs-task"
  is_enabled = var.is_enabled
  aws_region = var.aws_region

  task_config = [
    {
      name = "task1"
      container_definition_from_json = jsonencode([
        {
          name               = "app"
          image              = "cloudposse/geodesic"
          essential          = true
          interactive        = true
          pseudo_terminal    = true
          cpu                = 256
          memory             = 256
          memory_reservation = 128
          log_configuration = {
            log_driver = "json-file"
            options = {
              "max-file" = "3"
              "max-size" = "10m"
            }
          }
          port_mappings = [
            {
              container_port = 8080
              host_port      = 80
              protocol       = "tcp"
            },
            {
              container_port = 8081
              host_port      = 443
              protocol       = "udp"
            },
          ]
          extra_hosts = [
            {
              hostname   = "app.local"
              ip_address = "127.0.0.1"
            },
          ]
          mount_points              = []
          volumes_from              = []
          privileged                = false
          read_only_root_filesystem = false
        }
      ])
    },
    // Task 2
    {
      name = "task2"
      container_definition_from_json = jsonencode([
        {
          name               = "app"
          image              = "cloudposse/geodesic"
          essential          = true
          interactive        = true
          pseudo_terminal    = false
          cpu                = 256
          memory             = 256
          memory_reservation = 128
          log_configuration = {
            log_driver = "json-file"
            options = {
              "max-file" = "3"
              "max-size" = "10m"
            }
          }
          port_mappings = [
            {
              container_port = 8080
              host_port      = 80
              protocol       = "tcp"
            },
            {
              container_port = 8081
              host_port      = 443
              protocol       = "udp"
            },
          ]
          extra_hosts = [
            {
              hostname   = "app.local"
              ip_address = "127.0.0.1"
            },
          ]
          mount_points              = []
          volumes_from              = []
          privileged                = false
          read_only_root_filesystem = false
        }
      ])
    }
  ]
}
