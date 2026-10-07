# Cluster with one nodegroup (v2)

This environment will create a Selectel Cloud Project with a single MKS Cluster with one nodegroup,
using the `selectel_mks_cluster_v2` and `selectel_mks_nodegroup_v2` resources.
It is the [cluster_one_nodegroup](../cluster_one_nodegroup) example on the
[cluster_v2](../../../modules/mks/cluster_v2) and [nodegroup_v2](../../../modules/mks/nodegroup_v2) modules.

`selectel_mks_nodegroup_v2` takes the project from the provider configuration, so the nodegroup module
gets a second `selectel` provider, `selectel.project`, with `project_id` of the created project.

To move an existing cluster from the `_v1` resources, see [migrate_cluster_v1_to_v2](../migrate_cluster_v1_to_v2).

# Example usage

```sh
terraform init

env \
  TF_VAR_username="USER" \
  TF_VAR_password="PASSWORD" \
  TF_VAR_domain_name="ACCOUNT_ID" \
  terraform apply
```
