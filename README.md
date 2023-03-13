<h1 align="center">
  <img alt="logo" src="https://forum.huawei.com/enterprise/en/data/attachment/forum/202204/21/120858nak5g1epkzwq5gcs.png" width="224px"/><br/>
  Terraform AWS ☁️ Container 🐳
</h1>
<p align="center">An easy to understand, opinionated terraform <b>composable</b> set of modules for managing Containers and Workloads in <b> for AWS ☁️</b>.<br/><br/>

---

[![Auto Release](https://github.com/Excoriate/vault-labs/actions/workflows/release.yml/badge.svg)](https://github.com/Excoriate/vault-labs/actions/workflows/release.yml)
[![Terraform Check](https://github.com/Excoriate/terraform-registry-aws-accounts-creator/actions/workflows/ci-check-terraform.yml/badge.svg)](https://github.com/Excoriate/terraform-registry-aws-accounts-creator/actions/workflows/ci-check-terraform.yml)
[![Run pre-commit](https://github.com/Excoriate/terraform-registry-aws-accounts-creator/actions/workflows/ci-check-precommit.yml/badge.svg)](https://github.com/Excoriate/terraform-registry-aws-accounts-creator/actions/workflows/ci-check-precommit.yml)
[![Terratest](https://github.com/Excoriate/terraform-registry-aws-accounts-creator/actions/workflows/ci-pr-terratest.yml/badge.svg)](https://github.com/Excoriate/terraform-registry-aws-accounts-creator/actions/workflows/ci-pr-terratest.yml)


## Table of Contents

1. [About The Module](#about-the-module)
2. [Module documentation](#module-documentation)
   1. [Capabilities](#capabilities)
   2. [Getting Started](#getting-started)
   3. [Roadmap](#roadmap)
3. [Contributions](#contributing)
4[License](#license)
5. [Contact](#contact)



<!-- ABOUT THE PROJECT -->
## About The Module

This module encapsulate a set of modules that configure, and provision accounts-related resources on AWS.

---


## Module documentation

The documentation is **automatically generated** by [terraform-docs](https://terraform-docs.io), and it's available in the module's [README.md](modules/default/README.md) file.

### Capabilities

| Module                         | Status   | Description                                                                                                                           |
|--------------------------------|----------|---------------------------------------------------------------------------------------------------------------------------------------|
| `aws-ecr-container-registry`   | Stable ✅ | Create a fully managed, elastic container registry.                                                                                   |
| `aws-ecs-cluster`              | Stable ✅ | Create an ECS Cluster.                                                                                                                |
| `aws-app-autoscaling`          | Stable ✅ | Auto-scaling module, for different services. Currently it's supported `ECS`.                                                          |
| `aws-ecs-container-definition` | Stable ✅ | Helper module that enables the creation of a valid JSON that can be used as the container definition data of an ECS Task definition.. |
| `aws-ecs-task`                 | Stable ✅ | Implement a Task definition to run workloads in Elastic Container Services.                                                           |
| `aws-ecs-service`              | Stable ✅ | Implement an Elastic Container Service.                                                                                               |
| `aws-ecs-roles`                | Stable ✅ | Module that simplifies the creation of ecs task roles and ecs execution roles.                                                        |



### Getting Started

Check the example recipes 🥗 [here](examples)

### Roadmap

- [ ] Add more support for other type of targets, in the `auto-scaling` module.
- [ ] Add support for `ECS` IAM roles within the `ecs-roles` module. Currently it's only supporting `ecs-task` as trusted services when it's forming the IAM policy that's assummed.



## Contributing

Contributions are always encouraged and welcome! ❤️. For the process of accepting changes, please refer to the [CONTRIBUTING.md](./CONTRIBUTING.md) file, and for a more detailed explanation, please refer to this guideline [here](docs/contribution_guidelines.md).

## License

![license][badge-license]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

## Contact

- 📧 **Email**: [Alex T.](mailto:alex@ideaup.cl)
- 🧳 **Linkedin**: [Alex T.](https://www.linkedin.com/in/alextorresruiz/)

_made/with_ ❤️  🤟


<!-- References -->
[LICENSE]: ./LICENSE
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
