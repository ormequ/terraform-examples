variable "cluster_id" {}

variable "segment" {}

variable "nodes_count" {
  default = 1
}

variable "affinity_policy" {
  default = null
}

variable "cpus" {
  default = 1
}

variable "ram_mb" {
  default = 4096
}

variable "volume_gb" {
  default = 20
}

variable "volume_type" {
  default = null
}

variable "user_data" {
  default = null
}

variable "install_nvidia_device_plugin" {
  default = null
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "taints" {
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default = null
}

variable "dedicated_nodegroup_config" {
  type = object({
    service_uuid             = string
    price_plan_name          = string
    root_size_gb             = optional(number)
    create_storage_partition = optional(bool)
    currency                 = optional(string)
  })
  default = null
}

variable "cidr" {
  default = null
}
