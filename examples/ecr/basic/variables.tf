variable "is_enabled" {
  description = "Enable or disable the module"
  type        = bool
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ecr_config" {
  type = list(object({
    name                 = string
    image_tag_mutability = optional(string, "IMMUTABLE")
    scan_on_push         = optional(bool, true)
    encryption_configuration = optional(object({
      encryption_type = string
      kms_key         = optional(any, null)
    }), null)
  }))
  default     = null
  description = <<EOF
  A list of objects that contains the configuration for the ECR repositories.
  Each object must contain the following attributes:
  - name: The name of the ECR repository.
  - image_tag_mutability: The tag mutability setting for the repository. Must be one of: IMMUTABLE, MUTABLE.
  - scan_on_push: Indicates whether images are scanned after being pushed to the repository (true) or not (false).
  - encryption_configuration: An object that contains the encryption configuration for the repository. Can be null.
    If not null, it must contain the following attributes:
    - encryption_type: The encryption type to use for the repository. Must be one of: AES256, KMS.
    - kms_key: The ARN of the AWS Key Management Service (AWS KMS) customer master key (CMK) to use for encryption.
  EOF
}

variable "ecr_lifecycle_policy_config" {
  type = object({
    max_image_count = optional(number, 500)
    protected_tags  = optional(list(string), [])
  })
  default     = null
  description = <<EOF
  An object that contains the configuration for the ECR lifecycle policy.
  It must contain the following attributes:
  - max_image_count: The maximum number of images to keep in the repository.
  - protected_tags: A list of image tags to be excluded from the lifecycle policy.
  EOF
}
