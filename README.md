[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-google-gke-node-pool)

[![Build Status](https://github.com/mineiros-io/terraform-google-gke-node-pool/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-google-gke-node-pool/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-google-gke-node-pool.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-google-gke-node-pool/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version](https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-google/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-google-gke-node-pool

A [Terraform](https://www.terraform.io) module to create and manage Google
Kubernetes Engine (GKE)
[Node pools](https://cloud.google.com/container-engine/docs/node-pools).

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 4._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Main Resource Configuration](#main-resource-configuration)
  - [Extended Resource Configuration](#extended-resource-configuration)
- [External Documentation](#external-documentation)
  - [Google Documentation](#google-documentation)
  - [Terraform GCP Provider Documentation](#terraform-gcp-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module implements the following Terraform resources

- `google_container_node_pool`

## Getting Started

Most common usage of the module:

```hcl
module "terraform-google-gke-node-pool" {
  source = "git@github.com:mineiros-io/terraform-google-gke-node-pool.git?ref=v0.0.1"

  cluster_name = "name"
  project      = "project-id"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Main Resource Configuration

- [**`cluster_name`**](#var-cluster_name): *(**Required** `string`)*<a name="var-cluster_name"></a>

  The cluster to create the node pool for. Cluster must be present in
  location provided for zonal clusters.

- [**`project`**](#var-project): *(**Required** `string`)*<a name="var-project"></a>

  The ID of the project in which to create the node pool.

- [**`location`**](#var-location): *(Optional `string`)*<a name="var-location"></a>

  The location (region or zone) of the cluster.

- [**`node_locations`**](#var-node_locations): *(Optional `list(string)`)*<a name="var-node_locations"></a>

  The list of zones in which the node pool's nodes should be located.
  Nodes must be in the region of their regional cluster or in the same
  region as their cluster's zone for zonal clusters. If unspecified, the
  cluster-level node_locations will be used.

- [**`kubernetes_version`**](#var-kubernetes_version): *(Optional `string`)*<a name="var-kubernetes_version"></a>

  The Kubernetes version for the nodes in this pool. Note that if this
  field and `auto_upgrade` are both specified, they will fight each
  other for what the node version should be, so setting both is highly
  discouraged. While a fuzzy version can be specified, it's recommended
  that you specify explicit versions as Terraform will see spurious
  diffs when fuzzy versions are used. See the
  `google_container_engine_versions` data source's `version_prefix`
  field to approximate fuzzy versions in a Terraform-compatible way.

### Extended Resource Configuration

- [**`oauth_scopes`**](#var-oauth_scopes): *(Optional `string`)*<a name="var-oauth_scopes"></a>

  Scopes that are used by NAP when creating node pools. Use the
  https://www.googleapis.com/auth/cloud-platform scope to grant access
  to all APIs. It is recommended that you set `service_account` to a
  non-default service account and grant IAM roles to that service
  account for only the resources that it needs.

- [**`additional_oauth_scopes`**](#var-additional_oauth_scopes): *(Optional `list(string)`)*<a name="var-additional_oauth_scopes"></a>

  Scopes that are used by NAP when creating node pools. Use the
  https://www.googleapis.com/auth/cloud-platform scope to grant access
  to all APIs. It is recommended that you set `service_account` to a
  non-default service account and grant IAM roles to that service
  account for only the resources that it needs.

  Default is `[]`.

- [**`node_pools`**](#var-node_pools): *(Optional `list(node_pool)`)*<a name="var-node_pools"></a>

  Manages a node pool in a Google Kubernetes Engine (GKE) cluster
  separately from the cluster control plane.

  Each `node_pool` object in the list accepts the following attributes:

  - [**`name`**](#attr-node_pools-name): *(Optional `string`)*<a name="attr-node_pools-name"></a>

    The name of the node pool. If left blank, Terraform will auto-generate a unique name.

  - [**`name_prefix`**](#attr-node_pools-name_prefix): *(Optional `string`)*<a name="attr-node_pools-name_prefix"></a>

    Creates a unique name for the node pool beginning with the
    specified prefix. Conflicts with `name`.

  - [**`kubernetes_version`**](#attr-node_pools-kubernetes_version): *(Optional `string`)*<a name="attr-node_pools-kubernetes_version"></a>

    The Kubernetes version for the nodes in this pool. Note that if this
    field and `auto_upgrade` are both specified, they will fight each
    other for what the node version should be, so setting both is highly
    discouraged. While a fuzzy version can be specified, it's recommended
    that you specify explicit versions as Terraform will see spurious
    diffs when fuzzy versions are used. See the
    `google_container_engine_versions` data source's `version_prefix`
    field to approximate fuzzy versions in a Terraform-compatible way.

  - [**`max_pods_per_node`**](#attr-node_pools-max_pods_per_node): *(Optional `number`)*<a name="attr-node_pools-max_pods_per_node"></a>

    The maximum number of pods per node in this node pool. Note that
    this does not work on node pools which are "route-based" - that is,
    node pools belonging to clusters that do not have IP Aliasing
    enabled. See the [official documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr)
    for more information.

  - [**`max_surge`**](#attr-node_pools-max_surge): *(Optional `number`)*<a name="attr-node_pools-max_surge"></a>

    The number of additional nodes that can be added to the node pool
    during an upgrade. Increasing `max_surge` raises the number of nodes
    that can be upgraded simultaneously. Can be set to `0` or greater.

  - [**`max_unavailable`**](#attr-node_pools-max_unavailable): *(Optional `number`)*<a name="attr-node_pools-max_unavailable"></a>

    The number of nodes that can be simultaneously unavailable during
    an upgrade. Increasing `max_unavailable` raises the number of nodes
    that can be upgraded in parallel. Can be set to `0` or greater.

  - [**`auto_repair`**](#attr-node_pools-auto_repair): *(Optional `bool`)*<a name="attr-node_pools-auto_repair"></a>

    Whether the nodes will be automatically repaired.

    Default is `true`.

  - [**`auto_upgrade`**](#attr-node_pools-auto_upgrade): *(Optional `bool`)*<a name="attr-node_pools-auto_upgrade"></a>

    Whether the nodes will be automatically upgraded.

    Default is `false`.

  - [**`service_account`**](#attr-node_pools-service_account): *(Optional `string`)*<a name="attr-node_pools-service_account"></a>

    The service account to be used by the Node VMs. If not specified,
    the "default" service account is used.

  - [**`oauth_scopes`**](#attr-node_pools-oauth_scopes): *(Optional `set(string)`)*<a name="attr-node_pools-oauth_scopes"></a>

    Scopes that are used by NAP when creating node pools. Use the
    https://www.googleapis.com/auth/cloud-platform scope to grant
    access to all APIs. It is recommended that you set
    `service_account` to a non-default service account and grant IAM
    roles to that service account for only the resources that it
    needs.

  - [**`local_ssd_count`**](#attr-node_pools-local_ssd_count): *(Optional `number`)*<a name="attr-node_pools-local_ssd_count"></a>

    The amount of local SSD disks that will be attached to each
    cluster node.

    Default is `0`.

  - [**`disk_size_gb`**](#attr-node_pools-disk_size_gb): *(Optional `number`)*<a name="attr-node_pools-disk_size_gb"></a>

    Size of the disk attached to each node, specified in GB. The
    smallest allowed disk size is 10GB.

    Default is `100`.

  - [**`disk_type`**](#attr-node_pools-disk_type): *(Optional `string`)*<a name="attr-node_pools-disk_type"></a>

    Type of the disk attached to each node (e.g. `pd-standard`,
    `pd-balanced` or `pd-ssd`).

    Default is `"pd-standard"`.

  - [**`image_type`**](#attr-node_pools-image_type): *(Optional `string`)*<a name="attr-node_pools-image_type"></a>

    The image type to use for this node. Note that changing the image
    type will delete and recreate all nodes in the node pool.

    Default is `"COS"`.

  - [**`machine_type`**](#attr-node_pools-machine_type): *(Optional `string`)*<a name="attr-node_pools-machine_type"></a>

    The name of a Google Compute Engine machine type. To create a
    custom machine type, value should be set as specified
    [here](https://cloud.google.com/compute/docs/reference/latest/instances#machineType).

    Default is `"e2-medium"`.

  - [**`preemptible`**](#attr-node_pools-preemptible): *(Optional `bool`)*<a name="attr-node_pools-preemptible"></a>

    A boolean that represents whether or not the underlying node VMs
    are preemptible. See the [official documentation](https://cloud.google.com/container-engine/docs/preemptible-vm)
    for more information.

    Default is `false`.

  - [**`tags`**](#attr-node_pools-tags): *(Optional `list(string)`)*<a name="attr-node_pools-tags"></a>

    The list of instance tags applied to all nodes. Tags are used to
    identify valid sources or targets for network firewalls.

    Default is `[]`.

  - [**`metadata`**](#attr-node_pools-metadata): *(Optional `map(string)`)*<a name="attr-node_pools-metadata"></a>

    The metadata key/value pairs assigned to instances in the cluster.
    From GKE 1.12 onwards, disable-legacy-endpoints is set to true by
    the API; if metadata is set but that default value is not
    included, Terraform will attempt to unset the value. To avoid
    this, set the value in your config.

    Default is `{}`.

  - [**`min_cpu_platform`**](#attr-node_pools-min_cpu_platform): *(Optional `string`)*<a name="attr-node_pools-min_cpu_platform"></a>

    Minimum CPU platform to be used by this instance. The instance may
    be scheduled on the specified or newer CPU platform. Applicable
    values are the friendly names of CPU platforms, such as Intel
    Haswell. See the [official documentation](https://cloud.google.com/compute/docs/instances/specify-min-cpu-platform)
    for more information.

  - [**`enable_integrity_monitoring`**](#attr-node_pools-enable_integrity_monitoring): *(Optional `bool`)*<a name="attr-node_pools-enable_integrity_monitoring"></a>

    Defines whether the instance has integrity monitoring enabled.

    Default is `true`.

  - [**`enable_secure_boot`**](#attr-node_pools-enable_secure_boot): *(Optional `bool`)*<a name="attr-node_pools-enable_secure_boot"></a>

    Defines whether the instance has Secure Boot enabled.

    Default is `false`.

- [**`tags`**](#var-tags): *(Optional `list(string)`)*<a name="var-tags"></a>

  The list of instance tags applied to all nodes. Tags are used to
  identify valid sources or targets for network firewalls.

  Default is `[]`.

- [**`labels`**](#var-labels): *(Optional `list(string)`)*<a name="var-labels"></a>

  The list of instance tags applied to all nodes. Tags are used to
  identify valid sources or targets for network firewalls.

  Default is `[]`.

- [**`metadata`**](#var-metadata): *(Optional `map(string)`)*<a name="var-metadata"></a>

  The metadata key/value pairs assigned to instances in the cluster.
  From GKE 1.12 onwards, disable-legacy-endpoints is set to true by
  the API; if metadata is set but that default value is not
  included, Terraform will attempt to unset the value. To avoid
  this, set the value in your config.

  Default is `{}`.

- [**`node_metadata`**](#var-node_metadata): *(Optional `map(string)`)*<a name="var-node_metadata"></a>

  The metadata key/value pairs assigned to instances in the cluster.
  From GKE 1.12 onwards, disable-legacy-endpoints is set to true by
  the API; if metadata is set but that default value is not
  included, Terraform will attempt to unset the value. To avoid
  this, set the value in your config.

  Default is `{}`.

- [**`service_account`**](#var-service_account): *(Optional `string`)*<a name="var-service_account"></a>

  The service account to be used by the Node VMs. If not specified, the
  "default" service account is used.

- [**`max_unavailable`**](#var-max_unavailable): *(Optional `number`)*<a name="var-max_unavailable"></a>

  The number of nodes that can be simultaneously unavailable during
  an upgrade. Increasing `max_unavailable` raises the number of
  nodes that can be upgraded in parallel. Can be set to `0` or
  greater.

  Default is `0`.

- [**`max_surge`**](#var-max_surge): *(Optional `number`)*<a name="var-max_surge"></a>

  The number of additional nodes that can be added to the node pool
  during an upgrade. Increasing `max_surge` raises the number of
  nodes that can be upgraded simultaneously. Can be set to `0` or
  greater.

  Default is `1`.

## External Documentation

### Google Documentation

- https://cloud.google.com/container-engine/docs/node-pools

### Terraform GCP Provider Documentation

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

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-gke-node-pool
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-google-gke-node-pool/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-gke-node-pool/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-gke-node-pool/issues
[license]: https://github.com/mineiros-io/terraform-google-gke-node-pool/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-gke-node-pool/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-gke-node-pool/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-gke-node-pool/blob/main/CONTRIBUTING.md
