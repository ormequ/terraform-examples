variable "cluster_name" {
  default = "cluster-1"
}

variable "project_id" {}

variable "pool" {}

variable "kube_version" {}

variable "cluster_type" {
  default = null
}

variable "workers_type" {
  default = "CLOUD"
}

variable "enable_autorepair" {
  default = true
}

variable "enable_patch_version_auto_upgrade" {
  default = null
}

variable "network_id" {
  default = null
}

variable "subnet_id" {
  default = null
}

variable "maintenance_window_start" {
  default = null
}

variable "enable_audit_logs" {
  default = false
}
