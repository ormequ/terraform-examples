# Initialize Selectel provider with service user credentials.
provider "selectel" {
  username    = var.username
  password    = var.password
  domain_name = var.domain_name
  auth_region = var.pool
  auth_url    = var.auth_url
}

# selectel_mks_nodegroup_v2 takes the project from the provider configuration,
# and a dedicated nodegroup also takes the pool from it.
provider "selectel" {
  alias       = "project"
  username    = var.username
  password    = var.password
  domain_name = var.domain_name
  auth_region = var.pool
  auth_url    = var.auth_url
  project_id  = module.project.project_id
  region      = var.pool
}

module "project" {
  source = "../../../modules/cloud/project"

  project_name = var.project_name
}

data "selectel_dedicated_location_v1" "server_location" {
  project_id = module.project.project_id
  filter {
    name = var.segment
  }
}

data "selectel_dedicated_configuration_v1" "server_config" {
  project_id = module.project.project_id
  filter {
    name        = var.server_config_name
    location_id = data.selectel_dedicated_location_v1.server_location.locations[0].id
  }
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
  workers_type                      = "DEDICATED"
  enable_autorepair                 = var.enable_autorepair
  enable_patch_version_auto_upgrade = var.enable_patch_version_auto_upgrade
  maintenance_window_start          = var.maintenance_window_start
  enable_audit_logs                 = var.enable_audit_logs
}

module "kubernetes_nodegroup" {
  source = "../../../modules/mks/nodegroup_v2"
  providers = {
    selectel = selectel.project
  }

  cluster_id  = module.kubernetes_cluster.cluster_id
  segment     = var.segment
  nodes_count = var.nodes_count
  cidr        = var.cidr

  dedicated_nodegroup_config = {
    service_uuid             = data.selectel_dedicated_configuration_v1.server_config.configurations[0].id
    price_plan_name          = var.price_plan_name
    root_size_gb             = var.root_size_gb
    create_storage_partition = var.create_storage_partition
    currency                 = var.currency
  }

  labels = var.labels
  taints = var.taints
}
