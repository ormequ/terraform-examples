# Move a cluster from _v1 to _v2

This example moves a cluster created by the [cluster_one_nodegroup](../cluster_one_nodegroup) example
from `selectel_mks_cluster_v1` and `selectel_mks_nodegroup_v1` to `selectel_mks_cluster_v2` and
`selectel_mks_nodegroup_v2` without recreating it. `main.tf` is the final `_v2` configuration with the
`moved` blocks. The move changes only the Terraform state: the cluster, its nodegroups and nodes stay as they are.

The full mapping of the arguments is in the provider guide
[Migrating Managed Kubernetes resources from _v1 to _v2](https://registry.terraform.io/providers/selectel/selectel/latest/docs/guides/migrating_mks_to_v2).

## Before you start

1. Upgrade to a provider version that has the `_v2` resources.

2. Current provider versions require `auth_region` and `auth_url`. Add them to the `_v1` provider block,
or export `OS_REGION_NAME` and `OS_AUTH_URL`.

3. Run `terraform plan` with the `_v1` configuration. It must show no changes.

4. Write down the `kube_version` of the cluster from the `_v1` state. You pass it to this example as
`TF_VAR_kube_version`:

    ```sh
    terraform state show module.kubernetes_cluster.selectel_mks_cluster_v1.cluster_1
    ```

## Move with `moved` blocks (Terraform 1.8.0 and later)

1. Switch the module sources from `modules/mks/cluster` and `modules/mks/nodegroup` to
`modules/mks/cluster_v2` and `modules/mks/nodegroup_v2`, and change the module arguments:

    * cluster: `region` is now `pool`; set `workers_type = "CLOUD"`, because `_v1` creates only cloud clusters;
    if the `_v1` cluster had `zonal = true`, set `cluster_type = "BASIC"`;

    * cluster: set `kube_version` to the value from the `_v1` state instead of the kube versions data source.
    The default version of the data source can be higher than the version the cluster runs, and the plan
    would then upgrade the cluster;

    * cluster: keep `cluster_name` spelled as in `_v1`. The API stores the cluster name in lower case, and the
    provider compares it case-insensitively;

    * nodegroup: `availability_zone` is now `segment`; remove `project_id`, `region` and `keypair_name`.

    `zonal`, `enable_pod_security_policy` and `keypair_name` are removed from the `_v2` resources:
    remove them from the configuration.

2. Add a `selectel` provider with `project_id` and pass it to the nodegroup module, as `selectel.project` in `main.tf`:
`selectel_mks_nodegroup_v2` takes the project from the provider configuration. As an alternative,
set the `INFRA_PROJECT_ID` environment variable. The `project_id` must be the project of the cluster, which is
the `project_id` of the `_v1` nodegroup. With clusters in several projects, use one provider alias per project.

3. Add a `moved` block for the cluster and for each of its nodegroups. Move a cluster together with all
its nodegroups in the same run:

    ```hcl
    moved {
      from = module.kubernetes_cluster.selectel_mks_cluster_v1.cluster_1
      to   = module.kubernetes_cluster.selectel_mks_cluster_v2.cluster_1
    }

    moved {
      from = module.kubernetes_nodegroup.selectel_mks_nodegroup_v1.nodegroup_1
      to   = module.kubernetes_nodegroup.selectel_mks_nodegroup_v2.nodegroup_1
    }
    ```

4. Run `terraform plan`. Every resource must show `has moved to` and no changes. If the plan shows
any error, `must be replaced` or `forces replacement`, stop and do not apply. If it shows other
changes, compare the `_v2` arguments with the cluster: the values that `_v1` kept in the state are now
compared with the `_v2` configuration.

5. Run `terraform apply` to save the moved state. No API changes are made.

6. You can delete the `moved` blocks after every workspace that uses the configuration has applied them.

## Earlier Terraform versions

Terraform earlier than 1.8.0 cannot move state between resource types. Do steps 1 and 2 above, delete the `moved` blocks, lower
`required_version` in `versions.tf`, then remove the `_v1` resources from the state without destroying them
and import the `_v2` ones (in Terraform 1.7, `removed` blocks with `destroy = false` can replace
`terraform state rm`):

```sh
terraform state rm \
  module.kubernetes_nodegroup.selectel_mks_nodegroup_v1.nodegroup_1 \
  module.kubernetes_cluster.selectel_mks_cluster_v1.cluster_1

export INFRA_PROJECT_ID=<selectel_project_id>
export INFRA_REGION=<selectel_pool>
terraform import module.kubernetes_cluster.selectel_mks_cluster_v2.cluster_1 <cluster_id>
terraform import module.kubernetes_nodegroup.selectel_mks_nodegroup_v2.nodegroup_1 <cluster_id>/<nodegroup_id>
```

Then run `terraform plan`. If it shows any error, `must be replaced` or `forces replacement`, stop and
do not apply. The API does not return `cpus`, `ram_mb` and `affinity_policy` of a nodegroup, so
they stay empty after the import; the next `terraform apply` fills them from the configuration and does not
recreate the nodegroup. See the provider guide for the details.

# Example usage

```sh
terraform init -upgrade

env \
  TF_VAR_username="USER" \
  TF_VAR_password="PASSWORD" \
  TF_VAR_domain_name="ACCOUNT_ID" \
  TF_VAR_kube_version="KUBE_VERSION" \
  terraform plan
```
