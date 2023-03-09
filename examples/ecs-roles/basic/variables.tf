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
variable "execution_role_ooo_config" {
  type = list(object({
    // General settings
    name                    = string
    role_name               = optional(string, null)
    permissions_boundary    = optional(string, null)
    enable_ooo_role_common  = optional(bool, false)
    enable_ooo_role_fargate = optional(bool, false)
  }))
  default     = null
  description = <<EOF
  A list of objects that contains the settings for the Out-of-the-box execution role, compatible
with ECS (Task or ECS service).
The current attributes that are supported are:
- name: The unique identifier of this resource.
- role_name: The name of the role. If it's not passed, it'll take the name passed
  in the "name" attribute.
- permissions_boundary: The ARN of the policy that is used to set the permissions
- enable_ooo_role_common: Whether to enable the Out-of-the-box role for ECS
  (Task or ECS service) with common permissions.
- enable_ooo_role_fargate: Whether to enable the Out-of-the-box role for ECS
  (Task or ECS service) with Fargate permissions.
EOF
}

variable "execution_role_config" {
  type = list(object({
    name                 = string
    role_name            = optional(string, null)
    permissions_boundary = optional(string, null)
  }))
  default     = null
  description = <<EOF
  A list of objects that contains the settings for the custom execution role, compatible
with ECS (Task or ECS service).
The current attributes that are supported are:
- name: The unique identifier of this resource.
- role_name: The name of the role. If it's not passed, it'll take the name passed
  in the "name" attribute.
- permissions_boundary: The ARN of the policy that is used to set the permissions
EOF
}


variable "execution_role_permissions_config" {
  type = list(object({
    role_name                      = string
    policy_name                    = string
    resources                      = optional(list(string), ["*"])
    merge_with_default_permissions = optional(bool, false)
    actions                        = optional(list(string), ["*"])
    type                           = optional(string, "allow")
  }))
  default     = null
  description = <<EOF
  A list of objects that contains the settings for the permissions that will be attached
to the execution role, compatible with ECS (Task or ECS service).
The current attributes that are supported are:
- role_name: The name of the role. If it's not passed, it'll take the name passed
  in the "name" attribute.
- resources: The ARN of the resource that will be attached to the role.
- policy_name: The name of the policy that will be attached to the role. It's required for uniqueness of the underlying module.
- permissions: A list of strings that contains the permissions that will be
  attached to the role.
- actions: The action that will be performed with the permissions. The default
- merge_with_default_permissions: Whether to merge the permissions passed in
  this attribute with the default permissions. The default value is false.
- type: The type of the permission. The default value is "allow".
EOF
}
