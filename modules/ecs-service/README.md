<!-- BEGIN_TF_DOCS -->
# ☁️ ECS Service
## Description

This module creates an ECS service, which works with the specified task definition. The current and supported capabilities are:
- Create a service with a single task definition
- Create a service with a single task definition and a single load balancer

For more information about this specific resource, please visit its official documentation: [aws_ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service)

---
## Example
Examples of this module's usage are available in the [examples](./examples) folder.

```hcl
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
    },
    {
      cluster         = "tsn-sandbox-us-east-1-users-workload-users-ecs-fargate"
      name            = "service2"
      task_definition = module.task.ecs_task_definition_arn[0]
      enable_ignore_changes_on_desired_count = true
      enable_ignore_changes_on_task_definition = false
    },
    {
      cluster         = "tsn-sandbox-us-east-1-users-workload-users-ecs-fargate"
      name            = "service3"
      task_definition = module.task.ecs_task_definition_arn[0]
      enable_ignore_changes_on_desired_count = true
      enable_ignore_changes_on_task_definition = true
    }
  ]

  ecs_service_permissions_config = var.ecs_service_permissions_config
}
```

For module composition, It's recommended to take a look at the module's `outputs` to understand what's available:
```hcl
output "is_enabled" {
  value       = var.is_enabled
  description = "Whether the module is enabled or not."
}

output "aws_region_for_deploy_this" {
  value       = local.aws_region_to_deploy
  description = "The AWS region where the module is deployed."
}

output "tags_set" {
  value       = var.tags
  description = "The tags set for the module."
}

/*
-------------------------------------
Custom outputs
-------------------------------------
*/
output "ecs_service_name" {
  value       = length([for svc in aws_ecs_service.this : svc.name]) > 0 ? [for svc in aws_ecs_service.this : svc.name]: length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.name]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.name] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.name]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.name] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.name]
  description = "The name of the ECS service."
}

output "ecs_service_id" {
  value       = length([for svc in aws_ecs_service.this : svc.id]) > 0 ? [for svc in aws_ecs_service.this : svc.id]: length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.id]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.id] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.id]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.id] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.id]
  description = "The ARN of the ECS service."
}

output "ecs_service_cluster" {
  value       = length([for svc in aws_ecs_service.this : svc.cluster]) > 0 ? [for svc in aws_ecs_service.this : svc.cluster]: length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.cluster]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.cluster] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.cluster]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.cluster] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.cluster]
  description = "The ARN of the ECS service."
}

output "ecs_service_task_definition" {
  value       = length([for svc in aws_ecs_service.this : svc.task_definition]) > 0 ? [for svc in aws_ecs_service.this : svc.task_definition]: length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.task_definition]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.task_definition] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.task_definition]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.task_definition] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.task_definition]
  description = "The ARN of the ECS service."
}

output "ecs_service_launch_type" {
  value       = length([for svc in aws_ecs_service.this : svc.launch_type]) > 0 ? [for svc in aws_ecs_service.this : svc.launch_type]: length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.launch_type]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.launch_type] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.launch_type]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.launch_type] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.launch_type]
  description = "The launch type on which to run your service."
}

output "ecs_service_desired_count" {
  value       = length([for svc in aws_ecs_service.this : svc.desired_count]) > 0 ? [for svc in aws_ecs_service.this : svc.desired_count]: length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.desired_count]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.desired_count] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.desired_count]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.desired_count] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.desired_count]
  description = "The number of instances of the task definition to place and keep running."
}

output "ecs_service_deployment_maximum_percent" {
  value       = length([for svc in aws_ecs_service.this : svc.deployment_maximum_percent]) > 0 ? [for svc in aws_ecs_service.this : svc.deployment_maximum_percent]: length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.deployment_maximum_percent]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.deployment_maximum_percent] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.deployment_maximum_percent]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.deployment_maximum_percent] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.deployment_maximum_percent]
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment."
}

output "ecs_service_deployment_minimum_healthy_percent" {
  value       = length([for svc in aws_ecs_service.this : svc.deployment_minimum_healthy_percent]) > 0 ? [for svc in aws_ecs_service.this : svc.deployment_minimum_healthy_percent]: length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.deployment_minimum_healthy_percent]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.deployment_minimum_healthy_percent] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.deployment_minimum_healthy_percent]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.deployment_minimum_healthy_percent] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.deployment_minimum_healthy_percent]
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
}

output "ecs_service_health_check_grace_period_seconds" {
  value       = length([for svc in aws_ecs_service.this : svc.health_check_grace_period_seconds]) > 0 ? [for svc in aws_ecs_service.this : svc.health_check_grace_period_seconds]: length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.health_check_grace_period_seconds]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.health_check_grace_period_seconds] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.health_check_grace_period_seconds]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.health_check_grace_period_seconds] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.health_check_grace_period_seconds]
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647."
}

output "ecs_service_scheduling_strategy" {
  value       = length([for svc in aws_ecs_service.this : svc.scheduling_strategy]) > 0 ? [for svc in aws_ecs_service.this : svc.scheduling_strategy]: length([for svc in aws_ecs_service.ignore_task_definition_changes : svc.scheduling_strategy]) > 0 ? [for svc in aws_ecs_service.ignore_task_definition_changes : svc.scheduling_strategy] : length([for svc in aws_ecs_service.ignore_desired_count_changes : svc.scheduling_strategy]) > 0 ? [for svc in aws_ecs_service.ignore_desired_count_changes : svc.scheduling_strategy] : [for svc in aws_ecs_service.ignore_desired_count_and_task_definition_changes : svc.scheduling_strategy]
  description = "The scheduling strategy to use for the service."
}
```
---

## Module's documentation
(This documentation is auto-generated using [terraform-docs](https://terraform-docs.io))
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.58.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_service.ignore_desired_count_and_task_definition_changes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_service.ignore_desired_count_changes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_service.ignore_task_definition_changes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_iam_policy.fargate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.fargate_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48.0, < 5.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_ecs_service_config"></a> [ecs\_service\_config](#input\_ecs\_service\_config) | A list of objects that contains the configuration for each ECS service.<br>The currently supported attributes are:<br>- name: The name of the ECS service.<br>- task\_definition\_arn: The ARN of the task definition to use for the service.<br>- network\_mode: The network mode to use for the containers. The valid values are: bridge, awsvpc, host, and none. The default value is bridge.<br>- desire\_count: The number of instantiations of the specified task definition to place and keep running on your cluster.<br>- deployment\_maximum\_percent: The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment.<br>- deployment\_minimum\_healthy\_percent: The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment.<br>- health\_check\_grace\_period\_seconds: The period of time, in seconds, that the Amazon ECS service scheduler should ignore unhealthy Elastic Load Balancing target health checks after a task has first started.<br>- launch\_type: The launch type on which to run your service. The valid values are: EC2 and FARGATE. The default value is EC2.<br>- platform\_version: The platform version on which to run your service. Only applicable for launch type FARGATE. The valid values are: LATEST, 1.3.0, and 1.4.0. The default value is LATEST.<br>- scheduling\_strategy: The scheduling strategy to use for the service. The valid values are: REPLICA and DAEMON. The default value is REPLICA.<br>- enable\_ecs\_managed\_tags: Specifies whether to enable Amazon ECS managed tags for the tasks within the service. For more information, see Tagging Your Amazon ECS Resources in the Amazon Elastic Container Service Developer Guide.<br>- wait\_for\_steady\_state: Whether to wait for the service to reach a steady state after creating it. Defaults to true.<br>- force\_new\_deployment: Whether to force a new deployment of the service. Defaults to false.<br>- enable\_execute\_command: Whether to enable execute command functionality for the containers in this service. Defaults to false.<br>- cluster: The name of the cluster on which to run your service.<br>- target\_group\_config: A list of objects that contains the configuration for each target group.<br>- network\_config: A list of objects that contains the configuration for each network.<br>- propagate\_tags: Specifies whether to propagate the tags from the task definition or the service to the tasks in the service. The valid values are: TASK\_DEFINITION and SERVICE. The default value is SERVICE.<br>- enable\_deployment\_circuit\_breaker: Specifies whether to enable a deployment circuit breaker for the service. Defaults to false.<br>- trigger\_deploy\_on\_apply: Whether to trigger a new deployment of the service when the Terraform apply is executed. Defaults to false.<br>- enable\_ignore\_changes\_on\_desire\_count: Whether to ignore changes on the desire count of the service. Defaults to false.<br>- enable\_ignore\_changes\_on\_task\_definition: Whether to ignore changes on the task definition of the service. Defaults to false. | <pre>list(object({<br>    // General settings<br>    name                               = string<br>    task_definition                    = string<br>    desired_count                      = optional(number, 1)<br>    deployment_maximum_percent         = optional(number, 200)<br>    deployment_minimum_healthy_percent = optional(number, 100)<br>    health_check_grace_period_seconds  = optional(number, null)<br>    launch_type                        = optional(string, "FARGATE")<br>    platform_version                   = optional(string, "LATEST")<br>    scheduling_strategy                = optional(string, "REPLICA")<br>    enable_ecs_managed_tags            = optional(bool, false)<br>    wait_for_steady_state              = optional(bool, true)<br>    force_new_deployment               = optional(bool, false)<br>    enable_execute_command             = optional(bool, false)<br>    cluster                            = string<br>    propagate_tags                     = optional(string, "TASK_DEFINITION")<br>    enable_deployment_circuit_breaker  = optional(bool, false)<br>    trigger_deploy_on_apply            = optional(bool, false)<br>    enable_ignore_changes_on_desired_count = optional(bool, false)<br>    enable_ignore_changes_on_task_definition = optional(bool, false)<br><br>    // Load balancer config<br>    load_balancers_config = optional(list(object({<br>      target_group_arn = string<br>      container_name   = string<br>      container_port   = number<br>    })), [])<br><br>    // network configuration<br>    network_config = optional(object({<br>      mode             = optional(string, "awsvpc")<br>      subnets          = list(string)<br>      security_groups  = list(string)<br>      assign_public_ip = optional(bool, false)<br>    }), null)<br>  }))</pre> | `null` | no |
| <a name="input_ecs_service_permissions_config"></a> [ecs\_service\_permissions\_config](#input\_ecs\_service\_permissions\_config) | n/a | <pre>list(object({<br>    name                 = string<br>    execution_role_arn   = optional(string, null)<br>    iam_role_arn         = optional(string, null)<br>    permissions_boundary = optional(string, null)<br>  }))</pre> | `null` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Whether this module will be created or not. It is useful, for stack-composite<br>modules that conditionally includes resources provided by this module.. | `bool` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region_for_deploy_this"></a> [aws\_region\_for\_deploy\_this](#output\_aws\_region\_for\_deploy\_this) | The AWS region where the module is deployed. |
| <a name="output_ecs_service_cluster"></a> [ecs\_service\_cluster](#output\_ecs\_service\_cluster) | The ARN of the ECS service. |
| <a name="output_ecs_service_deployment_maximum_percent"></a> [ecs\_service\_deployment\_maximum\_percent](#output\_ecs\_service\_deployment\_maximum\_percent) | The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment. |
| <a name="output_ecs_service_deployment_minimum_healthy_percent"></a> [ecs\_service\_deployment\_minimum\_healthy\_percent](#output\_ecs\_service\_deployment\_minimum\_healthy\_percent) | The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment. |
| <a name="output_ecs_service_desired_count"></a> [ecs\_service\_desired\_count](#output\_ecs\_service\_desired\_count) | The number of instances of the task definition to place and keep running. |
| <a name="output_ecs_service_health_check_grace_period_seconds"></a> [ecs\_service\_health\_check\_grace\_period\_seconds](#output\_ecs\_service\_health\_check\_grace\_period\_seconds) | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. |
| <a name="output_ecs_service_id"></a> [ecs\_service\_id](#output\_ecs\_service\_id) | The ARN of the ECS service. |
| <a name="output_ecs_service_launch_type"></a> [ecs\_service\_launch\_type](#output\_ecs\_service\_launch\_type) | The launch type on which to run your service. |
| <a name="output_ecs_service_name"></a> [ecs\_service\_name](#output\_ecs\_service\_name) | The name of the ECS service. |
| <a name="output_ecs_service_scheduling_strategy"></a> [ecs\_service\_scheduling\_strategy](#output\_ecs\_service\_scheduling\_strategy) | The scheduling strategy to use for the service. |
| <a name="output_ecs_service_task_definition"></a> [ecs\_service\_task\_definition](#output\_ecs\_service\_task\_definition) | The ARN of the ECS service. |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the module is enabled or not. |
| <a name="output_tags_set"></a> [tags\_set](#output\_tags\_set) | The tags set for the module. |
<!-- END_TF_DOCS -->