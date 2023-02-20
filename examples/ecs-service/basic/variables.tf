variable "is_enabled" {
  description = "Enable or disable the module"
  type        = bool
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ecs_service_config" {
  type = list(object({
    // General settings
    name                               = string
    task_definition_arn                = string
    network_mode                       = optional(string, null)
    desired_count                      = optional(number, 1)
    deployment_maximum_percent         = optional(number, 200)
    deployment_minimum_healthy_percent = optional(number, 100)
    health_check_grace_period_seconds  = optional(number, 30)
    launch_type                        = optional(string, "FARGATE")
    platform_version                   = optional(string, "LATEST")
    scheduling_strategy                = optional(string, "REPLICA")
    enable_ecs_managed_tags            = optional(bool, false)
    wait_for_steady_state              = optional(bool, true)
    force_new_deployment               = optional(bool, false)
    enable_execute_command             = optional(bool, false)
    cluster                            = string

    // Permissions
    ecs_execution_role   = optional(string, null) // If null, it'll create the IAM Role as part of this module.
    ecs_iam_role         = optional(string, null) // optional, and only used if the network mode isn't awsvpc and there are load balancers configured.
    permissions_boundary = optional(string, null)

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
- ecs_execution_role: The name or full ARN of the IAM role that allows your Amazon ECS container task to make calls to other AWS services.
- ecs_iam_role: The name or full ARN of the IAM role that allows your Amazon ECS container task to make calls to other AWS services.
- permissions_boundary: The ARN of the policy that is used to set the permissions boundary for the task role and execution role for the task.
- target_group_config: A list of objects that contains the configuration for each target group.
  EOF
}

variable "ecs_extra_iam_policies" {
  type = list(object({
    ecs_service = string
    policy_arn  = string
    role_name   = optional(string, null)
  }))
  default     = null
  description = <<EOF
  A list of objects that contains the configuration for each extra IAM policy.
The currently supported attributes are:
- ecs_service: The name of the ECS service to attach the policy to.
- policy_arn: The ARN of the policy.
- role_name: The name of the role to attach the policy to. If not provided, it'll use the task role.
  EOF
}
