<!-- BEGIN_TF_DOCS -->
# ☁️ AWS ECR Container Registry
## Description

This module creates one or many ECR container registry, with the following capabilities:
* 🚀 Create the ECR container registry.
* 🚀 Create lifecycle policies. This option is optional, and disable by default.

---
## Example
Examples of this module's usage are available in the [examples](./examples) folder.

```hcl
module "main_module" {
  source                      = "../../../modules/ecr"
  is_enabled                  = var.is_enabled
  aws_region                  = var.aws_region
  ecr_config                  = var.ecr_config
  ecr_lifecycle_policy_config = var.ecr_lifecycle_policy_config
}
```

An example that implement a more complex ECR repository, with lifecycle policies on it
```hcl
aws_region = "us-east-1"
is_enabled = true

ecr_config = [
  {
    name                 = "my-ecr-repo-lifecycle"
    image_tag_mutability = "IMMUTABLE"
  }
]

ecr_lifecycle_policy_config = {
  max_image_count = 300
  protected_tags  = ["latest", "prod", "dev", "staging"]
}
```

An example that implement more than one (in this case, two) ECR repositories, with lifecycle policies on it
```hcl
aws_region = "us-east-1"
is_enabled = true

ecr_config = [
  {
    name                 = "my-ecr-repo-first"
    image_tag_mutability = "IMMUTABLE"
  },
  {
    name                 = "my-ecr-repo-second"
    image_tag_mutability = "IMMUTABLE"
  }
]

ecr_lifecycle_policy_config = {
  max_image_count = 300
  protected_tags  = ["latest", "prod", "dev", "staging"]
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
output "ecr_repository_url" {
  value       = [for repo in aws_ecr_repository.this : repo.repository_url]
  description = "The URL of the ECR repository."
}

output "ecr_repository_arn" {
  value       = [for repo in aws_ecr_repository.this : repo.arn]
  description = "The ARN of the ECR repository."
}

output "ecr_repository_name" {
  value       = [for repo in aws_ecr_repository.this : repo.name]
  description = "The name of the ECR repository."
}

output "ecr_repository_registry_id" {
  value       = [for repo in aws_ecr_repository.this : repo.registry_id]
  description = "The registry ID where the repository was created."
}


```
---

## Module's documentation
(This documentation is auto-generated using [terraform-docs](https://terraform-docs.io))
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.54.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |

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
| <a name="input_ecr_config"></a> [ecr\_config](#input\_ecr\_config) | A list of objects that contains the configuration for the ECR repositories.<br>  Each object must contain the following attributes:<br>  - name: The name of the ECR repository.<br>  - image\_tag\_mutability: The tag mutability setting for the repository. Must be one of: IMMUTABLE, MUTABLE.<br>  - scan\_on\_push: Indicates whether images are scanned after being pushed to the repository (true) or not (false).<br>  - encryption\_configuration: An object that contains the encryption configuration for the repository. Can be null.<br>    If not null, it must contain the following attributes:<br>    - encryption\_type: The encryption type to use for the repository. Must be one of: AES256, KMS.<br>    - kms\_key: The ARN of the AWS Key Management Service (AWS KMS) customer master key (CMK) to use for encryption. | <pre>list(object({<br>    name                 = string<br>    image_tag_mutability = optional(string, "IMMUTABLE")<br>    scan_on_push         = optional(bool, true)<br>    encryption_configuration = optional(object({<br>      encryption_type = string<br>      kms_key         = optional(any, null)<br>    }), null)<br>  }))</pre> | `null` | no |
| <a name="input_ecr_lifecycle_policy_config"></a> [ecr\_lifecycle\_policy\_config](#input\_ecr\_lifecycle\_policy\_config) | An object that contains the configuration for the ECR lifecycle policy.<br>  It must contain the following attributes:<br>  - max\_image\_count: The maximum number of images to keep in the repository.<br>  - protected\_tags: A list of image tags to be excluded from the lifecycle policy. | <pre>object({<br>    max_image_count = optional(number, 500)<br>    protected_tags  = optional(list(string), [])<br>  })</pre> | `null` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Whether this module will be created or not. It is useful, for stack-composite<br>modules that conditionally includes resources provided by this module.. | `bool` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region_for_deploy_this"></a> [aws\_region\_for\_deploy\_this](#output\_aws\_region\_for\_deploy\_this) | The AWS region where the module is deployed. |
| <a name="output_ecr_repository_arn"></a> [ecr\_repository\_arn](#output\_ecr\_repository\_arn) | The ARN of the ECR repository. |
| <a name="output_ecr_repository_name"></a> [ecr\_repository\_name](#output\_ecr\_repository\_name) | The name of the ECR repository. |
| <a name="output_ecr_repository_registry_id"></a> [ecr\_repository\_registry\_id](#output\_ecr\_repository\_registry\_id) | The registry ID where the repository was created. |
| <a name="output_ecr_repository_url"></a> [ecr\_repository\_url](#output\_ecr\_repository\_url) | The URL of the ECR repository. |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the module is enabled or not. |
| <a name="output_tags_set"></a> [tags\_set](#output\_tags\_set) | The tags set for the module. |
<!-- END_TF_DOCS -->
