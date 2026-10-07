variable "username" {}

variable "password" {}

variable "domain_name" {}

variable "auth_url" {
  default = "https://cloud.api.selcloud.ru/identity/v3"
}

variable "project_name" {
  default = "tf-project"
}

variable "cluster_name" {
  default = "tf-cluster-dedicated"
}

variable "pool" {
  default = "ru-1"
}

variable "enable_autorepair" {
  default = true
}

variable "enable_patch_version_auto_upgrade" {
  default = true
}

variable "maintenance_window_start" {
  default = null
}

variable "enable_audit_logs" {
  default = false
}

# Dedicated server location of the nodegroup in the pool.
variable "segment" {
  default = "SPB-3"
}

variable "server_config_name" {
  default = "CL25-NVMe"
}

variable "nodes_count" {
  default = 2
}

variable "cidr" {
  default = "10.20.30.0/24"
}

variable "price_plan_name" {
  default = "1 month"
}

variable "root_size_gb" {
  default = 100
}

variable "create_storage_partition" {
  default = true
}

variable "currency" {
  default = "main"
}

variable "labels" {
  default = {
    "label1" : "value1",
    "label2" : "value2"
  }
}

variable "taints" {
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default = [{
    effect = "NoSchedule"
    key    = "key1"
    value  = "value1"
  }]
}
