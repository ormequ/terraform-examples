# Nodegroup v2

Terraform module for creating a single Selectel MKS cloud or dedicated nodegroup with the `selectel_mks_nodegroup_v2` resource.
It replaces the [nodegroup](../nodegroup) module, which uses `selectel_mks_nodegroup_v1`.

`selectel_mks_nodegroup_v2` has no `project_id` and `region` arguments: it takes the project from the provider
configuration and the pool of a cloud nodegroup from `segment`. Pass this module a `selectel` provider with `project_id` set,
or set the `INFRA_PROJECT_ID` environment variable.

The nodegroup is a dedicated one when `dedicated_nodegroup_config` is set, and a cloud one otherwise.
A dedicated nodegroup needs a cluster with `workers_type = "DEDICATED"`, and it takes the pool from the provider
configuration: set `region` in the provider or the `INFRA_REGION` environment variable to the pool of the cluster.
The cloud variables `affinity_policy`, `cpus`, `ram_mb`, `volume_gb` and `volume_type` are ignored for a dedicated nodegroup.

## Variables

  * `cluster_id` - ID of the associated MKS cluster. A cloud nodegroup needs a cluster with `workers_type = "CLOUD"`,
  a dedicated one a cluster with `workers_type = "DEDICATED"`.

  * `segment` - A pool segment for all nodes in the nodegroup, for example, `ru-9a`.
  For a dedicated nodegroup, the dedicated server location, for example, `SPB-3`.

  * `nodes_count` - Count of worker nodes in the nodegroup (Default: 1).

  * `affinity_policy` - (Optional) Parameter to tune nodes affinity policy: `soft-anti-affinity` or `soft-affinity`.

  * `cpus` - CPU count for each node (Default: 1).

  * `ram_mb` - RAM count for each node (MB) (Default: 4096).

  * `volume_gb` - Volume size for each node (GB) (Default: 20).

  * `volume_type` - (Optional) An OpenStack blockstorage volume type for each node in the `<volume_type>.<segment>` format, for example, `fast.ru-9a`.

  * `dedicated_nodegroup_config` - (Optional) Dedicated server configuration of the nodes. Changing it creates a new node group.
  An object with:
    * `service_uuid` - ID of the dedicated server configuration, from the `configurations[].id` attribute
    of the `selectel_dedicated_configuration_v1` data source.
    * `price_plan_name` - Price plan of the servers: `1 day`, `1 month`, `3 months`, `6 months`, `12 months`
    or `12 months • monthly payment`.
    * `root_size_gb` - (Optional) Size of the root partition of each server in GB, at least `30` (Default: 100).
    * `create_storage_partition` - (Optional) Creates a storage partition on the fastest disk of each server (Default: true).
    * `currency` - (Optional) Balance that pays for the servers: `main` or `bonus` (Default: `main`).

  * `cidr` - (Optional) CIDR of the dedicated nodegroup network, a private `/24` network, for example, `10.20.30.0/24`.
  Dedicated nodegroups only.

  * `user_data` - (Optional) Base64-encoded script that worker nodes run on the first boot. Changing this creates a new node group. Learn more about [User data](https://docs.selectel.ru/en/cloud/managed-kubernetes/node-groups/user-data/).

  * `install_nvidia_device_plugin` - (Optional) Enables or disables installation of the NVIDIA Device Plugin and GPU drivers.
  If omitted, it is enabled for flavors with GPU. Learn more about [manual installation of GPU drivers](https://docs.selectel.ru/en/cloud/managed-kubernetes/node-groups/install-gpu-drivers/).

  * `labels` - (Optional) Map of user-defined Kubernetes labels, that will be applied for each node in the group.

  * `taints` - (Optional) List of user-defined Kubernetes taints, that will be applied for each node in the group.
  Each taint is an object with `key`, `value` and `effect`.

## Outputs

  * `nodegroup_id` - ID of the created MKS nodegroup in the `<cluster_id>/<nodegroup_id>` format.
