terraform {
  required_providers {
    selectel = {
      source  = "selectel/selectel"
      version = ">= 9.0.0"
    }
  }
  # A moved block between resource types needs Terraform 1.8.0 or later.
  required_version = ">= 1.8.0"
}
