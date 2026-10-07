terraform {
  required_providers {
    selectel = {
      source = "selectel/selectel"
      # selectel_mks_cluster_v2 and selectel_mks_nodegroup_v2 need the provider
      # release that ships them: raise this constraint to that version.
      version = ">= 5.1.1"
    }
  }
  required_version = ">= 1.9.2"
}
