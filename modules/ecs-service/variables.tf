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
variable "task_config" {
  type = list(object({
    // General settings
    name                           = string
    family                         = optional(string, null)
    container_definition_from_json = optional(string, "")
    container_definition_from_file = string
    type                           = optional(string, "FARGATE")
    network_mode                   = optional(string, "awsvpc")
    // Capacity
    cpu    = optional(number, 256)
    memory = optional(number, 512)
    // Permissions
    ecs_role_arn         = optional(string, null) // If null, it'll create the IAM Role as part of this module.
    task_role_arn        = optional(string, null) // If null, it'll create the IAM Role as part of this module.
    permissions_boundary = optional(string, null)
  }))
}
