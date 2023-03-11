module "task" {
  source     = "../../../modules/ecs-task"
  is_enabled = var.is_enabled
  aws_region = var.aws_region

  task_config = [
    {
      name         = "task1"
      network_mode = null
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
  ]
}


#resource "aws_iam_policy" "test_extra_iam_policy" {
#  name   = "test_extra_iam_policy"
#  policy = data.aws_iam_policy_document.test_extra_iam_policy_doc.json
#}
#
#data "aws_iam_policy_document" "test_extra_iam_policy_doc" {
#  statement {
#    effect    = "Allow"
#    resources = ["*"]
#
#    actions = [
#      "ec2:Describe*",
#    ]
#  }
#}


module "main_module" {
  source     = "../../../modules/ecs-service"
  is_enabled = var.is_enabled
  aws_region = var.aws_region

  ecs_service_config = [
    {
      cluster         = "tsn-sandbox-us-east-1-users-workload-users-ecs-fargate"
      name            = "service1"
      task_definition = module.task.ecs_task_definition_arn[0]
    }
  ]

  ecs_service_permissions_config = var.ecs_service_permissions_config
}
