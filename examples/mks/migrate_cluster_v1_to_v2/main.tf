# The cluster_one_nodegroup example after the move to the _v2 resources.
# The moved blocks move the _v1 state of the cluster and the nodegroup
# to the _v2 resources without changing the cluster itself.

# Initialize Selectel provider with service user credentials.
provider "selectel" {
  username    = var.username
  password    = var.password
  domain_name = var.domain_name
  auth_region = var.pool
  auth_url    = var.auth_url
}

# selectel_mks_nodegroup_v2 takes the project from the provider configuration.
provider "selectel" {
  alias       = "project"
  username    = var.username
  password    = var.password
  domain_name = var.domain_name
  auth_region = var.pool
  auth_url    = var.auth_url
  project_id  = module.project.project_id
}

moved {
  from = module.kubernetes_cluster.selectel_mks_cluster_v1.cluster_1
  to   = module.kubernetes_cluster.selectel_mks_cluster_v2.cluster_1
}

moved {
  from = module.kubernetes_nodegroup.selectel_mks_nodegroup_v1.nodegroup_1
  to   = module.kubernetes_nodegroup.selectel_mks_nodegroup_v2.nodegroup_1
}

module "project" {
  source = "../../../modules/cloud/project"

  project_name = var.project_name
}

data "selectel_mks_kube_versions_v2" "versions" {
  project_id = module.project.project_id
  pool       = var.pool
}

module "kubernetes_cluster" {
  source = "../../../modules/mks/cluster_v2"

  cluster_name                      = var.cluster_name
  project_id                        = module.project.project_id
  pool                              = var.pool
  kube_version                      = data.selectel_mks_kube_versions_v2.versions.default_version
  workers_type                      = "CLOUD"
  enable_autorepair                 = var.enable_autorepair
  enable_patch_version_auto_upgrade = var.enable_patch_version_auto_upgrade
  network_id                        = var.network_id
  subnet_id                         = var.subnet_id
  maintenance_window_start          = var.maintenance_window_start
  enable_audit_logs                 = var.enable_audit_logs
}

module "kubernetes_nodegroup" {
  source = "../../../modules/mks/nodegroup_v2"
  providers = {
    selectel = selectel.project
  }

  cluster_id                   = module.kubernetes_cluster.cluster_id
  segment                      = var.segment
  nodes_count                  = var.nodes_count
  affinity_policy              = var.affinity_policy
  cpus                         = var.cpus
  ram_mb                       = var.ram_mb
  volume_gb                    = var.volume_gb
  volume_type                  = var.volume_type
  user_data                    = var.user_data
  install_nvidia_device_plugin = var.install_nvidia_device_plugin
  labels                       = var.labels
  taints                       = var.taints
}
