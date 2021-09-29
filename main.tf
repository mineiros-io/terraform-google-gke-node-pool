locals {
  base_oauth_scopes = [
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/trace.append",
  ]

  oauth_scopes = var.oauth_scopes != null ? var.oauth_scopes : compact(concat(local.base_oauth_scopes, var.additional_oauth_scopes))

  node_pools = { for node in var.node_pools : node.name => node }
}

resource "google_container_node_pool" "current" {
  for_each = local.node_pools

  project = var.project
  cluster = var.cluster_name

  name        = try(each.value.name, null)
  name_prefix = try(each.value.name_prefix, null)

  # From the docs:Note that if this field and auto_upgrade are both specified,
  #    they will fight each other for what the node version should be,
  #    so setting both is highly discouraged
  # => if auto_upgrade is set to true we ignore any kubernetes_version that is set
  version = try(each.value.auto_upgrade, false) ? null : try(each.value.kubernetes_version, var.kubernetes_version)

  location       = try(each.value.location, var.location, null)
  node_locations = try(each.value.node_locations, var.node_locations, null)

  autoscaling {
    min_node_count = try(each.value.min_node_count, 0)
    max_node_count = try(each.value.max_node_count, each.value.initial_node_count, each.value.min_node_count, 1)
  }

  max_pods_per_node = try(each.value.max_pods_per_node, null)

  upgrade_settings {
    max_surge       = try(each.value.max_surge, var.max_surge)
    max_unavailable = try(each.value.max_unavailable, var.max_unavailable)
  }

  management {
    auto_repair  = try(each.value.auto_repair, true)
    auto_upgrade = try(each.value.auto_upgrade, false)
  }

  node_config {
    service_account = try(each.value.service_account, var.service_account)

    oauth_scopes = try(each.value.oauth_scopes, local.oauth_scopes)

    local_ssd_count = try(each.value.local_ssd_count, 0)
    disk_size_gb    = try(each.value.disk_size_gb, 100)
    disk_type       = try(each.value.disk_type, "pd-standard")

    image_type   = try(each.value.image_type, "COS")
    machine_type = try(each.value.machine_type, "e2-medium")
    preemptible  = try(each.value.preemptible, false)

    #     labels = merge(var.labels, try(each.value.labels, {}))
    #
    tags = distinct(compact(concat(tolist(var.tags), try(tolist(each.value.tags), []))))

    metadata = merge(var.metadata, try(each.value.metadata, {}), {
      # From GKE 1.12 onwards, disable-legacy-endpoints is set to true by the API;
      # if metadata is set but that default value is not included, Terraform will attempt to unset the value.
      # To avoid this, set the value in your config.
      "disable-legacy-endpoints" = true
    })

    min_cpu_platform = try(each.value.min_cpu_platform, null)

    shielded_instance_config {
      enable_secure_boot          = try(each.value.enable_secure_boot, false)
      enable_integrity_monitoring = try(each.value.enable_integrity_monitoring, true)
    }

    # workload_metadata_config {
    #   node_metadata = try(each.value.node_metadata, var.node_metadata)
    # }

    # TODO: guest_accelerator - (Optional) List of the type and count of accelerator cards attached to the instance. Structure documented below.
    #  To support removal of guest_accelerators in Terraform 0.12 this field is an Attribute as Block
    guest_accelerator = try(each.value.guest_accelerator, [])


    # DO NOT ADD: taint (should be managed in k8s itself)
    #   tain - (Optional) A list of Kubernetes taints to apply to nodes.
    #     GKE's API can only set this field on cluster creation.
    #     However, GKE will add taints to your nodes if you enable certain features such as GPUs.
    #     If this field is set, any diffs on this field will cause Terraform to recreate the underlying resource.
    #     Taint values can be updated safely in Kubernetes (eg. through kubectl),
    #     and it's recommended that you do not use this field to manage taints.
    #     If you do, lifecycle.ignore_changes is recommended. Structure is documented below.

    # missing beta features:
    #   sandbox_config - (Optional, Beta) GKE Sandbox configuration. When enabling this feature you must specify image_type = "COS_CONTAINERD" and node_version = "1.12.7-gke.17" or later to use it. Structure is documented below.
    #   boot_disk_kms_key - (Optional, Beta) The Customer Managed Encryption Key used to encrypt the boot disk attached to each node in the node pool. This should be of the form projects/[KEY_PROJECT_ID]/locations/[LOCATION]/keyRings/[RING_NAME]/cryptoKeys/[KEY_NAME]. For more information about protecting resources with Cloud KMS Keys please see: https://cloud.google.com/compute/docs/disks/customer-managed-encryption
    #   kubelet_config - (Optional, Beta) Kubelet configuration, currently supported attributes can be found here. Structure is documented below.
    #     kubelet_config {
    #       cpu_manager_policy   = "static"
    #       cpu_cfs_quota        = true
    #       cpu_cfs_quota_period = "100us"
    #     }
    #   linux_node_config - (Optional, Beta) Linux node configuration, currently supported attributes can be found here. Note that validations happen all server side. All attributes are optional. Structure is documented below.
  }

  # DO NOT USE: initial_node_count due to it's destructive behavior
  # initial_node_count = null
  initial_node_count = try(each.value.initial_node_count, 1)
  # initial_node_count:
  #   The initial number of nodes for the pool.
  #   In regional or multi-zonal clusters, this is the number of nodes per zone.
  #   Changing this will force recreation of the resource.
  #   WARNING: Resizing your node pool manually may change this value in your existing cluster,
  #   which will trigger destruction and recreation on the next Terraform run (to rectify the discrepancy).
  #   If you don't need this value, don't set it.
  #   If you do need it, you can use a lifecycle block to ignore subsqeuent changes to this field.
  lifecycle {
    ignore_changes = [initial_node_count]
  }
}
