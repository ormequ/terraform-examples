resource "selectel_mks_nodegroup_v2" "nodegroup_1" {
  cluster_id  = var.cluster_id
  segment     = var.segment
  nodes_count = var.nodes_count

  # Exactly one of the two configs is set: a dedicated one when given, a cloud one otherwise.
  cloud_nodegroup_config = var.dedicated_nodegroup_config == null ? {
    cpus            = var.cpus
    ram_mb          = var.ram_mb
    volume_gb       = var.volume_gb
    volume_type     = var.volume_type
    affinity_policy = var.affinity_policy
  } : null

  dedicated_nodegroup_config = var.dedicated_nodegroup_config
  cidr                       = var.cidr

  user_data                    = var.user_data
  install_nvidia_device_plugin = var.install_nvidia_device_plugin
  labels                       = var.labels
  taints                       = var.taints
}
