# Cluster with one dedicated nodegroup (v2)

This environment will create a Selectel Cloud Project with a single MKS Cluster with one nodegroup
of dedicated servers, using the `selectel_mks_cluster_v2` and `selectel_mks_nodegroup_v2` resources
on the [cluster_v2](../../../modules/mks/cluster_v2) and [nodegroup_v2](../../../modules/mks/nodegroup_v2) modules.
The server configuration comes from the `selectel_dedicated_configuration_v1` data source,
filtered by name and by the location of the nodegroup.

  * Dedicated nodegroups need a cluster with `workers_type = "DEDICATED"`.
  A cloud nodegroup cannot be added to such a cluster, and a dedicated nodegroup cannot be added
  to a cluster with `workers_type = "CLOUD"`.

  * Changing `workers_type` creates a new cluster with all its nodegroups.

  * The servers of the nodegroup are ordered and billed by the price plan in `price_plan_name`.

  * A dedicated nodegroup takes the pool from the provider configuration, so the `selectel.project`
  provider of the nodegroup module also sets `region`. `segment` is a dedicated server location in that pool,
  for example, `SPB-3` in `ru-1`.

  * A dedicated nodegroup has no autoscaling. Ordering and installing the servers can take up to 160 minutes.

For a nodegroup of cloud servers, see [cluster_one_nodegroup_v2](../cluster_one_nodegroup_v2).

# Example usage

```sh
terraform init

env \
  TF_VAR_username="USER" \
  TF_VAR_password="PASSWORD" \
  TF_VAR_domain_name="ACCOUNT_ID" \
  terraform apply
```
