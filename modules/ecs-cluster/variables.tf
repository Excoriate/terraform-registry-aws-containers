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
variable "ecs_cluster_config" {
  type = list(object({
    name                      = string
    enable_container_insights = optional(bool, false)
    providers = optional(object({
      type = optional(string, "FARGATE_SPOT")
      default_capacity_provider_strategy = optional(list(object({
        capacity_provider = optional(string, "FARGATE_SPOT")
        weight            = optional(number, 1)
        base              = optional(number, 0)
      })), null)
    }), null)
    cluster_configuration = optional(object({
      execute_command_configuration = optional(object({
        kms_key_id = optional(string, null)
        logging    = optional(string, null)
      }), null)
    }), null)
  }))
  description = <<EOF
  Configuration for the ECS cluster. The allowed parameters are:
  - name: The name of the ECS cluster.
  - enable_container_insights: Whether to enable CloudWatch Container Insights for the ECS cluster.
  - providers: The capacity providers to associate with the cluster.
  - cluster_configuration: The execute command configuration for the cluster.
  EOF
  default     = null
}
