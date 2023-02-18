variable "is_enabled" {
  description = "Enable or disable the module"
  type        = bool
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "task_config" {
  type = list(object({
    // General settings
    name                           = string
    family                         = optional(string, null)
    container_definition_from_json = optional(string, null)
    container_definition_from_file = optional(string, null)
    type                           = optional(string, "FARGATE")
    network_mode                   = optional(string, "awsvpc")
    // Capacity
    cpu    = optional(number, 256)
    memory = optional(number, 512)
    // Permissions
    task_role_arn              = optional(string, null) // If null, it'll create the IAM Role as part of this module.
    enable_default_permissions = optional(bool, true)
    permissions_boundary       = optional(string, null)
  }))
  default     = null
  description = <<EOF
  A list of objects that contains the configuration for each task definition.
The currently supported attributes are:
- name: The name of the task definition.
- family: The family of the task definition. If not provided, it'll use the name.
- container_definition_from_json: The JSON string that contains the container definition.
- container_definition_from_file: The path to the file that contains the container definition.
- type: The type of the task definition. Valid values are: EC2, FARGATE. Default: FARGATE.
- network_mode: The network mode of the task definition. Valid values are: awsvpc, bridge, host, none. Default: awsvpc.
- cpu: The number of CPU units to reserve for the container. Default: 256.
- memory: The amount of memory (in MiB) to allow the container to use. Default: 512.
- task_role_arn: The ARN of the IAM role that allows your Amazon ECS container task to make calls to other AWS services.
- enable_default_permissions: Whether to enable the default permissions for the task role. Default: true.
- permissions_boundary: The ARN of the policy that is used to set the permissions boundary for the task role.
  EOF
}
