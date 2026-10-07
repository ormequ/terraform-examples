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
