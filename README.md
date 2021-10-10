[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Terraform Version][badge-terraform]][releases-terraform]
[![Google Provider Version][badge-tf-gcp]][releases-google-provider]
[![Join Slack][badge-slack]][slack]

# terraform-google-gke-node-pool

A [Terraform](https://www.terraform.io) module to create a [Google GKE Node Pools](https://cloud.google.com/kubernetes-engine/docs/concepts/node-pools) on [Google Cloud Services (GCP)](https://cloud.google.com/).

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 3._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.

- [terraform-google-gke-node-pool](#terraform-google-gke-node-pool)
  - [Module Features](#module-features)
  - [Getting Started](#getting-started)
  - [Module Argument Reference](#module-argument-reference)
    - [Top-level Arguments](#top-level-arguments)
      - [Module Configuration](#module-configuration)
      - [Main Resource Configuration](#main-resource-configuration)
      - [Extended Resource Configuration](#extended-resource-configuration)
  - [Module Attributes Reference](#module-attributes-reference)
  - [External Documentation](#external-documentation)
    - [Google Documentation:](#google-documentation)
    - [Terraform Google Provider Documentation:](#terraform-google-provider-documentation)
  - [Module Versioning](#module-versioning)
    - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
  - [About Mineiros](#about-mineiros)
  - [Reporting Issues](#reporting-issues)
  - [Contributing](#contributing)
  - [Makefile Targets](#makefile-targets)
  - [License](#license)

## Module Features

A [Terraform] base module for creating a `google_container_node_pool` resources required to manage a node pools in a (GKE) cluster.

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-google-gke-node-pool" {
  source = "github.com/mineiros-io/terraform-google-gke-node-pool.git?ref=v0.1.0"

  cluster_name    = google_container_cluster.primary.id
  project         = "example-project"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- **`module_enabled`**: _(Optional `bool`)_

  Specifies whether resources in the module will be created.

  Default is `true`.

- **`module_depends_on`**: _(Optional `list(dependencies)`)_

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

  Example:
  ```hcl
  module_depends_on = [
    google_container_cluster.primary.id
  ]
  ```

#### Main Resource Configuration

- **`cluster_name`**: **_(Required `string`)_**

  The cluster to create the node pool for. Cluster must be present in location provided for zonal clusters.

- **`project`**: **_(Required `string`)_**

  The ID of the project in which to create the node pool.

- **`location`**: _(Optional `string`)_

  The location (region or zone) of the cluster.

- **`node_location`**: _(Optional `list(string)`)_

  The list of zones in which the node pool's nodes should be located. Nodes must be in the region of their regional cluster or in the same region as their cluster's zone for zonal clusters. If unspecified, the cluster-level node_locations will be used.

- **`kubernetes_version`**: _(Optional `string`)_

  The Kubernetes version for the nodes in this pool. Note that if this field and `auto_upgrade` are both specified, they will fight each other for what the node version should be, so setting both is highly discouraged.

- **`oauth_scopes`**: _(Optional `set(string)`)_

  Scopes that are used by NAP when creating node pools. It is recommended that you set `service_account` to a non-default service account and grant IAM roles to that service account for only the resources that it needs.

  Default is `[]`.

- **`additional_oauth_scopes`**: _(Optional `list(string)`)_

  Additional oauth scopes.

  Default is `[]`.

- **`tags`**: _(Optional `set(string)`)_

  The list of instance tags applied to all nodes.

  Default is `[]`.

- **`labels`**: _(Optional `map(string)`)_

  A map of labels for the resource created.

  Default is `{}`.

- **`metadata`**: _(Optional `map(string)`)_

  The metadata key/value pairs assigned to instances in the cluster.

  Default is `{}`.

- **`node_metadata`**: _(Optional `map(string)`)_

  How to expose the node metadata to the workload running on the node. Accepted values are:
  - `UNSPECIFIED`: Not Set
  - `SECURE`: Prevent workloads not in hostNetwork from accessing certain VM metadata, specifically `kube-env`, which contains Kubelet credentials, and the instance identity token.
  - `EXPOSE`: Expose all VM metadata to pods.
  - `GKE_METADATA_SERVER`: Enables workload identity on the node

  Default is `{}`.

- **`service_account`**: _(Optional `string`)_

  The service account to be used by the Node VMs.

- **`max_unavailable`**: _(Optional `number`)_

  The number of nodes that can be simultaneously unavailable during an upgrade. Increasing `max_unavailable` raises the number of nodes that can be upgraded in parallel. Can be set to `0` or greater.

  Default is `0`.

- **`max_surge`**: _(Optional `number`)_

  The number of additional nodes that can be added to the node pool during an upgrade. Increasing `max_surge` raises the number of nodes that can be upgraded simultaneously. Can be set to `0` or greater.

  Default is `1`.

- **`node_pools`**: _(Optional `list(node_pools)`)_

  List of node pools associated with this cluster.

  Default is `[]`.

  Each `node_pool` object has the following attributes:

  - **`name`**: _(Optional `string`)_

    A name for the node pool.

  - **`name_prefix`**: _(Optional `list(string)`)_

    A name prefix for the node pool.

#### Extended Resource Configuration

## Module Attributes Reference

The following attributes are exported in the outputs of the module:

- **`module_enabled`**

  Whether this module is enabled.

## External Documentation

### Google Documentation:

- Kubernetes engine node poles: https://cloud.google.com/kubernetes-engine/docs/concepts/node-pools

### Terraform Google Provider Documentation:

- https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2021 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-gke-node-pool
[hello@mineiros.io]: mailto:hello@mineiros.io


[badge-build]: https://github.com/mineiros-io/terraform-google-gke-node-pool/workflows/Tests/badge.svg

<!-- markdown-link-check-enable -->

[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-google-gke-node-pool.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

<!-- markdown-link-check-disabled -->

[build-status]: https://github.com/mineiros-io/terraform-google-gke-node-pool/actions
[releases-github]: https://github.com/mineiros-io/terraform-google-gke-node-pool/releases

<!-- markdown-link-check-enable -->

[releases-terraform]: https://github.com/hashicorp/terraform/releases
[badge-tf-gcp]: https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform
[releases-google-provider]: https://github.com/terraform-providers/terraform-provider-google/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[gcp]: https://cloud.google.com/
[semantic versioning (semver)]: https://semver.org/

<!-- markdown-link-check-disabled -->

[variables.tf]: https://github.com/mineiros-io/terraform-google-gke-node-pool/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-gke-node-pool/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-gke-node-pool/issues
[license]: https://github.com/mineiros-io/terraform-google-gke-node-pool/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-gke-node-pool/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-gke-node-pool/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-gke-node-pool/blob/main/CONTRIBUTING.md

<!-- markdown-link-check-enable -->
