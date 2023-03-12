variable "is_enabled" {
  type        = bool
  description = <<EOF
  Whether this module will be created or not. It is useful, for stack-composite
modules that conditionally includes resources provided by this module..
EOF
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy the resources"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources."
  default     = {}
}

/*
-------------------------------------
Custom input variables
-------------------------------------
*/
variable "ecs_service_permissions_config" {
  type = list(object({
    name                 = string
    execution_role_arn   = optional(string, null)
    iam_role_arn         = optional(string, null)
    permissions_boundary = optional(string, null)
  }))
  default = null

}

variable "ecs_service_config" {
  type = list(object({
    // General settings
    name                                     = string
    task_definition                          = string
    desired_count                            = optional(number, 1)
    deployment_maximum_percent               = optional(number, 200)
    deployment_minimum_healthy_percent       = optional(number, 100)
    health_check_grace_period_seconds        = optional(number, null)
    launch_type                              = optional(string, "FARGATE")
    platform_version                         = optional(string, "LATEST")
    scheduling_strategy                      = optional(string, "REPLICA")
    enable_ecs_managed_tags                  = optional(bool, false)
    wait_for_steady_state                    = optional(bool, true)
    force_new_deployment                     = optional(bool, false)
    enable_execute_command                   = optional(bool, false)
    cluster                                  = string
    propagate_tags                           = optional(string, "TASK_DEFINITION")
    enable_deployment_circuit_breaker        = optional(bool, false)
    trigger_deploy_on_apply                  = optional(bool, false)
    enable_ignore_changes_on_desired_count   = optional(bool, false)
    enable_ignore_changes_on_task_definition = optional(bool, false)

    // Load balancer config
    load_balancers_config = optional(list(object({
      target_group_arn = string
      container_name   = string
      container_port   = number
    })), [])

    // network configuration
    network_config = optional(object({
      mode             = optional(string, "awsvpc")
      subnets          = list(string)
      security_groups  = list(string)
      assign_public_ip = optional(bool, false)
    }), null)
  }))
  default     = null
  description = <<EOF
  A list of objects that contains the configuration for each ECS service.
The currently supported attributes are:
- name: The name of the ECS service.
- task_definition_arn: The ARN of the task definition to use for the service.
- network_mode: The network mode to use for the containers. The valid values are: bridge, awsvpc, host, and none. The default value is bridge.
- desire_count: The number of instantiations of the specified task definition to place and keep running on your cluster.
- deployment_maximum_percent: The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment.
- deployment_minimum_healthy_percent: The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment.
- health_check_grace_period_seconds: The period of time, in seconds, that the Amazon ECS service scheduler should ignore unhealthy Elastic Load Balancing target health checks after a task has first started.
- launch_type: The launch type on which to run your service. The valid values are: EC2 and FARGATE. The default value is EC2.
- platform_version: The platform version on which to run your service. Only applicable for launch type FARGATE. The valid values are: LATEST, 1.3.0, and 1.4.0. The default value is LATEST.
- scheduling_strategy: The scheduling strategy to use for the service. The valid values are: REPLICA and DAEMON. The default value is REPLICA.
- enable_ecs_managed_tags: Specifies whether to enable Amazon ECS managed tags for the tasks within the service. For more information, see Tagging Your Amazon ECS Resources in the Amazon Elastic Container Service Developer Guide.
- wait_for_steady_state: Whether to wait for the service to reach a steady state after creating it. Defaults to true.
- force_new_deployment: Whether to force a new deployment of the service. Defaults to false.
- enable_execute_command: Whether to enable execute command functionality for the containers in this service. Defaults to false.
- cluster: The name of the cluster on which to run your service.
- target_group_config: A list of objects that contains the configuration for each target group.
- network_config: A list of objects that contains the configuration for each network.
- propagate_tags: Specifies whether to propagate the tags from the task definition or the service to the tasks in the service. The valid values are: TASK_DEFINITION and SERVICE. The default value is SERVICE.
- enable_deployment_circuit_breaker: Specifies whether to enable a deployment circuit breaker for the service. Defaults to false.
- trigger_deploy_on_apply: Whether to trigger a new deployment of the service when the Terraform apply is executed. Defaults to false.
- enable_ignore_changes_on_desire_count: Whether to ignore changes on the desire count of the service. Defaults to false.
- enable_ignore_changes_on_task_definition: Whether to ignore changes on the task definition of the service. Defaults to false.
  EOF
}
