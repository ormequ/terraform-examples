terraform {
  required_providers {
    selectel = {
      source = "selectel/selectel"
    }
  }
  # Optional object attributes in a variable type need Terraform 1.3.0 or later.
  required_version = ">= 1.3.0"
}
