
variable "cluster_name" {
  type        = string
  description = "(Required) The cluster to create the node pool for. Cluster must be present in location provided for zonal clusters."
}

variable "location" {
  type        = string
  description = "(Optional) The location (region or zone) of the cluster."
  default     = null
}
#
# variable "autoscaling" {
#   type        = string
#   description = "(Optional) Configuration required by cluster autoscaler to adjust the size of the node pool to the current cluster usage."
#   default     = null
# }
#
# variable "initial_node_count" {
#   type        = string
#   description = "(Optional) The initial number of nodes for the pool. In regional or multi-zonal clusters, this is the number of nodes per zone. Changing this will force recreation of the resource. WARNING: Resizing your node pool manually may change this value in your existing cluster, which will trigger destruction and recreation on the next Terraform run (to rectify the discrepancy). If you don't need this value, don't set it. If you do need it, you can use a lifecycle block to ignore subsqeuent changes to this field."
#   default     = null
# }
#
# variable "management" {
#   type        = string
#   description = "(Optional) Node management configuration, wherein auto-repair and auto-upgrade is configured. Structure is documented below."
#   default     = null
# }
#
# variable "max_pods_per_node" {
#   type        = string
#   description = "(Optional) The maximum number of pods per node in this node pool. Note that this does not work on node pools which are 'route-based' - that is, node pools belonging to clusters that do not have IP Aliasing enabled. See the official documentation for more information."
#   default     = null
# }
#
variable "node_locations" {
  type        = list(string)
  description = "(Optional) The list of zones in which the node pool's nodes should be located. Nodes must be in the region of their regional cluster or in the same region as their cluster's zone for zonal clusters. If unspecified, the cluster-level node_locations will be used."
  default     = null
}
#
# variable "name" {
#   type        = string
#   description = "(Optional) The name of the node pool. If left blank, Terraform will auto-generate a unique name."
#   default     = null
# }
#
# variable "name_prefix" {
#   type        = string
#   description = "(Optional) Creates a unique name for the node pool beginning with the specified prefix. Conflicts with name."
#   default     = null
# }
#
# variable "node_config" {
#   type        = string
#   description = "(Optional) The node configuration of the pool. See google_container_cluster for schema."
#   default     = null
# }
#
# variable "node_count" {
#   type        = string
#   description = "(Optional) The number of nodes per instance group. This field can be used to update the number of nodes per instance group but should not be used alongside autoscaling."
#   default     = null
# }
#
variable "project" {
  type        = string
  description = "(Required) The ID of the project in which to create the node pool."
}
#
# variable "upgrade_settings" {
#   type        = string
#   description = "ptional) Specify node upgrade settings to change how many nodes GKE attempts to upgrade at once. The number of nodes upgraded simultaneously is the sum of max_surge and max_unavailable. The maximum number of nodes upgraded simultaneously is limited to 20."
#   default     = null
# }
#
variable "kubernetes_version" {
  type        = string
  description = "(Optional) The Kubernetes version for the nodes in this pool. Note that if this field and auto_upgrade are both specified, they will fight each other for what the node version should be, so setting both is highly discouraged. While a fuzzy version can be specified, it's recommended that you specify explicit versions as Terraform will see spurious diffs when fuzzy versions are used. See the google_container_engine_versions data source's version_prefix field to approximate fuzzy versions in a Terraform-compatible way."
  default     = null
}

# global defaults for node_config

variable "oauth_scopes" {
  type        = set(string)
  description = "(Optional, Default for node_pool)"
  default     = null
}

variable "additional_oauth_scopes" {
  type        = list(string)
  description = "(Optional, Default for node_pool)"
  default     = []
}

variable "node_pools" {
  type        = any
  description = "(Optional, Default for node_config)"
  default     = []
}

variable "tags" {
  type        = set(string)
  description = "(Optional, Default for node_config)"
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "(Optional, Default for node_config)"
  default     = {}
}

variable "metadata" {
  type        = map(string)
  description = "(Optional, Default for node_config)"
  default     = {}
}

variable "node_metadata" {
  type        = map(string)
  description = "(Optional, Default for node_config)"
  default     = {}
}

variable "service_account" {
  type        = string
  description = "(Optional, Default for node_config)"
  default     = null
}

variable "max_unavailable" {
  type        = number
  description = "(Optional, Default for node_pool)"
  default     = 0
}

variable "max_surge" {
  type        = number
  description = "(Optional, Default for node_pool)"
  default     = 1
}
