# Changelog

## [1.1.0](https://github.com/Excoriate/terraform-registry-aws-containers/compare/v1.0.0...v1.1.0) (2023-05-21)


### Features

* add autoscaling module ([1100ea4](https://github.com/Excoriate/terraform-registry-aws-containers/commit/1100ea49cb6c221b2aecc1822b0ddd710c79cda5))
* add better auto-scaling module ([250abac](https://github.com/Excoriate/terraform-registry-aws-containers/commit/250abac7928d46d0d20ae6197d7c9bbb3292e5aa))
* add built-in policies for task role ([26c99da](https://github.com/Excoriate/terraform-registry-aws-containers/commit/26c99dab508e676bb96c91d6ad57ece20c790f64))
* add capability for the ecs-role with custom policies ([d4d12d5](https://github.com/Excoriate/terraform-registry-aws-containers/commit/d4d12d5ed980201072dae14d81bcc93b90373c81))
* add container definition module ([9d23944](https://github.com/Excoriate/terraform-registry-aws-containers/commit/9d239449864dc252aa5d7f10157f15fe3e9ffa8d))
* add disable built-in permissions for ecs service module ([36a6999](https://github.com/Excoriate/terraform-registry-aws-containers/commit/36a6999e9a0049e9674d22fd03e5bb0fce6ee718))
* add ecs container definition module ([e1f0ef5](https://github.com/Excoriate/terraform-registry-aws-containers/commit/e1f0ef50bf6f0ad5d447d1fdd668f17eead46a8b))
* add ecs roles module ([7f1a36e](https://github.com/Excoriate/terraform-registry-aws-containers/commit/7f1a36e7d910b09c5a2397c2b5dfb9b1b9be899a))
* add ecs service module ([38fca39](https://github.com/Excoriate/terraform-registry-aws-containers/commit/38fca39379a5d36d75865856b33acdb78838f384))
* add ecs task module ([a7cbbec](https://github.com/Excoriate/terraform-registry-aws-containers/commit/a7cbbec377cf72da1e3410e59f379304d471f021))
* add ecs-service ignore changes variations ([a3fa8b4](https://github.com/Excoriate/terraform-registry-aws-containers/commit/a3fa8b481a3d3354218387a466d54a1378ca8c42))
* add extra policies to the task ([4fa1ce5](https://github.com/Excoriate/terraform-registry-aws-containers/commit/4fa1ce5546a9178ca71744ebfc37795c1c518a7f))
* add flag to ecs-task to force disabling built-in permissions ([5ccbce9](https://github.com/Excoriate/terraform-registry-aws-containers/commit/5ccbce9121f4cea45dc46d021f69822a0a3e50fc))
* add new ecs-task module version, with ignore-changes capabilities ([ec21a23](https://github.com/Excoriate/terraform-registry-aws-containers/commit/ec21a23217c001b8d9b74694247bdf38a4841ef3))
* add reformulated ecs-task module ([bcfe120](https://github.com/Excoriate/terraform-registry-aws-containers/commit/bcfe120521b842621b3e63714d7f37d3eeb2f9b4))
* add support for force deletion in ecr module, add release-please ([923859d](https://github.com/Excoriate/terraform-registry-aws-containers/commit/923859ddc61af480fdf25ccc63f3c5fa26f18f7e))
* first commit ([c275e4e](https://github.com/Excoriate/terraform-registry-aws-containers/commit/c275e4e4fa2c3070f9aedce30b63adbf7722fb00))
* fix lb configuration on ecs-service ([c58def8](https://github.com/Excoriate/terraform-registry-aws-containers/commit/c58def84dfa83a2833e915c8a15ba6990f850bbf))


### Bug Fixes

* amend ecs-task module ([0864d35](https://github.com/Excoriate/terraform-registry-aws-containers/commit/0864d3584a89abd5855759f3ec25764ab6d06a9e))
* ci add updated workflow for tagging ([623be67](https://github.com/Excoriate/terraform-registry-aws-containers/commit/623be674f0706193b4aa3ec6900f1a5148cf0cac))
* flag was not working ([0a1febc](https://github.com/Excoriate/terraform-registry-aws-containers/commit/0a1febc1ec34261f368c9ccd19eb88124fc92a0e))
* network configuration inconsistent condition in ecs service ([0c0cf6a](https://github.com/Excoriate/terraform-registry-aws-containers/commit/0c0cf6ad34485113c819f9b06d11ab7afd56bcf7))
* network mode in ecs module ([ed77d18](https://github.com/Excoriate/terraform-registry-aws-containers/commit/ed77d18f2421394de65793fd25dbeab223736e34))
* sid normalised ([eca9cb1](https://github.com/Excoriate/terraform-registry-aws-containers/commit/eca9cb19bc9d8d72d3ad42b17a4201c6fe9721a8))


### Refactoring

* enhance ecs-service with permissions config ([1473c64](https://github.com/Excoriate/terraform-registry-aws-containers/commit/1473c64f548d0429e2dd0bba1ffb42765aae2007))
* expose output values from ecs-roles module ([710bd19](https://github.com/Excoriate/terraform-registry-aws-containers/commit/710bd190e7f343c5bb9ef68b05c9ed79e582336c))
* expose the manage outside of terraform to the ecs-task module ([bd9543c](https://github.com/Excoriate/terraform-registry-aws-containers/commit/bd9543cf1d98ee7041f0107bbbfff1b58df36913))
