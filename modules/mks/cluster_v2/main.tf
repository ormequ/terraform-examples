resource "selectel_mks_cluster_v2" "cluster_1" {
  name                              = var.cluster_name
  project_id                        = var.project_id
  pool                              = var.pool
  kube_version                      = var.kube_version
  cluster_type                      = var.cluster_type
  workers_type                      = var.workers_type
  enable_autorepair                 = var.enable_autorepair
  enable_patch_version_auto_upgrade = var.enable_patch_version_auto_upgrade
  network_id                        = var.network_id
  subnet_id                         = var.subnet_id
  maintenance_window_start          = var.maintenance_window_start
  kubernetes_options = {
    audit_logs = {
      enabled = var.enable_audit_logs
    }
  }
}
