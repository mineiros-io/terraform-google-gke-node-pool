header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-gke-node-pool"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-google-gke-node-pool/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-google-gke-node-pool/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-gke-node-pool.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-google-gke-node-pool/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-gke-node-pool"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) module to create and manage Google
    Kubernetes Engine (GKE)
    [Node pools](https://cloud.google.com/container-engine/docs/node-pools).

    **_This module supports Terraform version 1
    and is compatible with the Terraform Google Provider version 4._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      This module implements the following Terraform resources

      - `google_container_node_pool`
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most common usage of the module:

      ```hcl
      module "terraform-google-gke-node-pool" {
        source = "git@github.com:mineiros-io/terraform-google-gke-node-pool.git?ref=v0.0.1"

        cluster_name = "name"
        project      = "project-id"
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Main Resource Configuration"

      variable "cluster_name" {
        required    = true
        type        = string
        description = <<-END
          The cluster to create the node pool for. Cluster must be present in
          location provided for zonal clusters.
        END
      }

      variable "project" {
        required    = true
        type        = string
        description = <<-END
          The ID of the project in which to create the node pool.
        END
      }

      variable "location" {
        type        = string
        description = <<-END
          The location (region or zone) of the cluster.
        END
      }

      variable "node_locations" {
        type        = list(string)
        description = <<-END
          The list of zones in which the node pool's nodes should be located.
          Nodes must be in the region of their regional cluster or in the same
          region as their cluster's zone for zonal clusters. If unspecified, the
          cluster-level node_locations will be used.
        END
      }

      variable "kubernetes_version" {
        type        = string
        description = <<-END
          The Kubernetes version for the nodes in this pool. Note that if this
          field and `auto_upgrade` are both specified, they will fight each
          other for what the node version should be, so setting both is highly
          discouraged. While a fuzzy version can be specified, it's recommended
          that you specify explicit versions as Terraform will see spurious
          diffs when fuzzy versions are used. See the
          `google_container_engine_versions` data source's `version_prefix`
          field to approximate fuzzy versions in a Terraform-compatible way.
        END
      }
    }

    section {
      title = "Extended Resource Configuration"

      variable "oauth_scopes" {
        type        = string
        description = <<-END
          Scopes that are used by NAP when creating node pools. Use the
          https://www.googleapis.com/auth/cloud-platform scope to grant access
          to all APIs. It is recommended that you set `service_account` to a
          non-default service account and grant IAM roles to that service
          account for only the resources that it needs.
        END
      }

      variable "additional_oauth_scopes" {
        type        = list(string)
        default     = []
        description = <<-END
          Scopes that are used by NAP when creating node pools. Use the
          https://www.googleapis.com/auth/cloud-platform scope to grant access
          to all APIs. It is recommended that you set `service_account` to a
          non-default service account and grant IAM roles to that service
          account for only the resources that it needs.
        END
      }

      variable "node_pools" {
        type        = list(node_pool)
        description = <<-END
          Manages a node pool in a Google Kubernetes Engine (GKE) cluster
          separately from the cluster control plane.
        END

        attribute "name" {
          type        = string
          description = <<-END
            The name of the node pool. If left blank, Terraform will auto-generate a unique name.
          END
        }

        attribute "name_prefix" {
          type        = string
          description = <<-END
            Creates a unique name for the node pool beginning with the
            specified prefix. Conflicts with `name`.
          END
        }

        attribute "kubernetes_version" {
          type        = string
          description = <<-END
            The Kubernetes version for the nodes in this pool. Note that if this
            field and `auto_upgrade` are both specified, they will fight each
            other for what the node version should be, so setting both is highly
            discouraged. While a fuzzy version can be specified, it's recommended
            that you specify explicit versions as Terraform will see spurious
            diffs when fuzzy versions are used. See the
            `google_container_engine_versions` data source's `version_prefix`
            field to approximate fuzzy versions in a Terraform-compatible way.
          END
        }

        attribute "max_pods_per_node" {
          type        = number
          description = <<-END
            The maximum number of pods per node in this node pool. Note that
            this does not work on node pools which are "route-based" - that is,
            node pools belonging to clusters that do not have IP Aliasing
            enabled. See the official documentation for more information:
            https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr
          END
        }

        attribute "max_surge" {
          type        = number
          description = <<-END
            The number of additional nodes that can be added to the node pool
            during an upgrade. Increasing `max_surge` raises the number of nodes
            that can be upgraded simultaneously. Can be set to `0` or greater.
          END
        }

        attribute "max_unavailable" {
          type        = number
          description = <<-END
            The number of nodes that can be simultaneously unavailable during
            an upgrade. Increasing `max_unavailable` raises the number of nodes
            that can be upgraded in parallel. Can be set to `0` or greater.
          END
        }

        attribute "auto_repair" {
          type        = bool
          default     = true
          description = <<-END
            Whether the nodes will be automatically repaired.
          END
        }

        attribute "auto_upgrade" {
          type        = bool
          default     = false
          description = <<-END
            Whether the nodes will be automatically upgraded.
          END
        }

        attribute "service_account" {
          type        = string
          description = <<-END
            The service account to be used by the Node VMs. If not specified,
            the "default" service account is used.
          END
        }

        attribute "oauth_scopes" {
          type        = set(string)
          description = <<-END
            Scopes that are used by NAP when creating node pools. Use the
            https://www.googleapis.com/auth/cloud-platform scope to grant
            access to all APIs. It is recommended that you set
            `service_account` to a non-default service account and grant IAM
            roles to that service account for only the resources that it
            needs.
          END
        }

        attribute "local_ssd_count" {
          type        = number
          default     = 0
          description = <<-END
            The amount of local SSD disks that will be attached to each
            cluster node.
          END
        }

        attribute "disk_size_gb" {
          type        = number
          default     = 100
          description = <<-END
            Size of the disk attached to each node, specified in GB. The
            smallest allowed disk size is 10GB.
          END
        }

        attribute "disk_type" {
          type        = string
          default     = "pd-standard"
          description = <<-END
            Type of the disk attached to each node (e.g. `pd-standard`,
            `pd-balanced` or `pd-ssd`).
          END
        }

        attribute "image_type" {
          type        = string
          default     = "COS"
          description = <<-END
            The image type to use for this node. Note that changing the image
            type will delete and recreate all nodes in the node pool.
          END
        }

        attribute "machine_type" {
          type        = string
          default     = "e2-medium"
          description = <<-END
            The name of a Google Compute Engine machine type. To create a
            custom machine type, value should be set as specified
            [here](https://cloud.google.com/compute/docs/reference/latest/instances#machineType).
          END
        }

        attribute "preemptible" {
          type        = bool
          default     = false
          description = <<-END
            A boolean that represents whether or not the underlying node VMs
            are preemptible. See the [official documentation](https://cloud.google.com/container-engine/docs/preemptible-vm)
            for more information.
          END
        }

        attribute "tags" {
          type        = list(string)
          default     = []
          description = <<-END
            The list of instance tags applied to all nodes. Tags are used to
            identify valid sources or targets for network firewalls.
          END
        }

        attribute "metadata" {
          type        = map(string)
          default     = {}
          description = <<-END
            The metadata key/value pairs assigned to instances in the cluster.
            From GKE 1.12 onwards, disable-legacy-endpoints is set to true by
            the API; if metadata is set but that default value is not
            included, Terraform will attempt to unset the value. To avoid
            this, set the value in your config.
          END
        }

        attribute "min_cpu_platform" {
          type        = string
          description = <<-END
            Minimum CPU platform to be used by this instance. The instance may
            be scheduled on the specified or newer CPU platform. Applicable
            values are the friendly names of CPU platforms, such as Intel
            Haswell. See the [official documentation](https://cloud.google.com/compute/docs/instances/specify-min-cpu-platform)
            for more information.
          END
        }

        attribute "enable_integrity_monitoring" {
          type        = bool
          default     = true
          description = <<-END
            Defines whether the instance has integrity monitoring enabled.
          END
        }

        attribute "enable_secure_boot" {
          type        = bool
          default     = false
          description = <<-END
            Defines whether the instance has Secure Boot enabled.
          END
        }
      }

      variable "tags" {
        type        = list(string)
        default     = []
        description = <<-END
          The list of instance tags applied to all nodes. Tags are used to
          identify valid sources or targets for network firewalls.
        END
      }

      variable "labels" {
        type        = list(string)
        default     = []
        description = <<-END
          The list of instance tags applied to all nodes. Tags are used to
          identify valid sources or targets for network firewalls.
        END
      }

      variable "metadata" {
        type        = map(string)
        default     = {}
        description = <<-END
          The metadata key/value pairs assigned to instances in the cluster.
          From GKE 1.12 onwards, disable-legacy-endpoints is set to true by
          the API; if metadata is set but that default value is not
          included, Terraform will attempt to unset the value. To avoid
          this, set the value in your config.
        END
      }

      variable "node_metadata" {
        type        = map(string)
        default     = {}
        description = <<-END
          The metadata key/value pairs assigned to instances in the cluster.
          From GKE 1.12 onwards, disable-legacy-endpoints is set to true by
          the API; if metadata is set but that default value is not
          included, Terraform will attempt to unset the value. To avoid
          this, set the value in your config.
        END
      }

      variable "service_account" {
        type        = string
        description = <<-END
          The service account to be used by the Node VMs. If not specified, the
          "default" service account is used.
        END
      }

      variable "max_unavailable" {
        type        = number
        default     = 0
        description = <<-END
          The number of nodes that can be simultaneously unavailable during
          an upgrade. Increasing `max_unavailable` raises the number of
          nodes that can be upgraded in parallel. Can be set to `0` or
          greater.
        END
      }

      variable "max_surge" {
        type        = number
        default     = 1
        description = <<-END
          The number of additional nodes that can be added to the node pool
          during an upgrade. Increasing `max_surge` raises the number of
          nodes that can be upgraded simultaneously. Can be set to `0` or
          greater.
        END
      }
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "Google Documentation"
      content = <<-END
        - https://cloud.google.com/container-engine/docs/node-pools
      END
    }

    section {
      title   = "Terraform GCP Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-gke-node-pool"
  }
  ref "hello@mineiros.io" {
    value = " mailto:hello@mineiros.io"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "aws" {
    value = "https://aws.amazon.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-gke-node-pool/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-gke-node-pool/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-gke-node-pool/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-gke-node-pool/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-gke-node-pool/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-gke-node-pool/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-gke-node-pool/blob/main/CONTRIBUTING.md"
  }
}
