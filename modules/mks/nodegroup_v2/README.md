# Nodegroup v2

Terraform module for creating a single Selectel MKS cloud nodegroup with the `selectel_mks_nodegroup_v2` resource.
It replaces the [nodegroup](../nodegroup) module, which uses `selectel_mks_nodegroup_v1`.

`selectel_mks_nodegroup_v2` has no `project_id` and `region` arguments: it takes the project from the provider
configuration and the pool from `segment`. Pass this module a `selectel` provider with `project_id` set,
or set the `INFRA_PROJECT_ID` environment variable.

## Variables

  * `cluster_id` - ID of the associated MKS cluster. The cluster must have `workers_type = "CLOUD"`.

  * `segment` - A pool segment for all nodes in the nodegroup, for example, `ru-9a`.

  * `nodes_count` - Count of worker nodes in the nodegroup (Default: 1).

  * `affinity_policy` - (Optional) Parameter to tune nodes affinity policy: `soft-anti-affinity` or `soft-affinity`.

  * `cpus` - CPU count for each node (Default: 1).

  * `ram_mb` - RAM count for each node (MB) (Default: 4096).

  * `volume_gb` - Volume size for each node (GB) (Default: 20).

  * `volume_type` - An OpenStack blockstorage volume type for each node in the `<volume_type>.<segment>` format, for example, `fast.ru-9a`.

  * `user_data` - (Optional) Base64-encoded script that worker nodes run on the first boot. Changing this creates a new node group. Learn more about [User data](https://docs.selectel.ru/en/cloud/managed-kubernetes/node-groups/user-data/).

  * `install_nvidia_device_plugin` - (Optional) Enables or disables installation of the NVIDIA Device Plugin and GPU drivers.
  If omitted, it is enabled for flavors with GPU. Learn more about [manual installation of GPU drivers](https://docs.selectel.ru/en/cloud/managed-kubernetes/node-groups/install-gpu-drivers/).

  * `labels` - (Optional) Map of user-defined Kubernetes labels, that will be applied for each node in the group.

  * `taints` - (Optional) List of user-defined Kubernetes taints, that will be applied for each node in the group.
  Each taint is an object with `key`, `value` and `effect`.

## Outputs

  * `nodegroup_id` - ID of the created MKS nodegroup in the `<cluster_id>/<nodegroup_id>` format.
