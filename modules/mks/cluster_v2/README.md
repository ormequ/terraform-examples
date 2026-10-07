# Cluster v2

Terraform module for creating a single Selectel MKS cluster with the `selectel_mks_cluster_v2` resource.
It replaces the [cluster](../cluster) module, which uses `selectel_mks_cluster_v1`.

## Variables

  * `cluster_name` - The name of the cluster (Default: "cluster-1").

  * `project_id` - An associated Selectel Cloud project.

  * `pool` - A Selectel Cloud pool of where the cluster is located, for example, `ru-9`.

  * `kube_version` - The current Kubernetes version of the cluster in the `x.y.z` format.

  * `cluster_type` - (Optional) The type of the cluster: `BASIC`, `HIGH_AVAILABILITY` or `HIGH_AVAILABILITY_MULTI_AZ`.
  If omitted, the provider default `HIGH_AVAILABILITY` is used.

  * `workers_type` - The type of the worker nodes the cluster accepts: `CLOUD` or `DEDICATED` (Default: "CLOUD").
  Use `CLOUD` for a cluster created by `selectel_mks_cluster_v1`.

  * `enable_autorepair` - Reflects if worker nodes are allowed to be reinstalled automatically (Default: true).

  * `enable_patch_version_auto_upgrade` - (Optional) Specifies if Kubernetes patch version of the cluster is allowed
  to be upgraded automatically. If omitted, it is enabled for all cluster types except `BASIC`.

  * `network_id` - (Optional) An OpenStack Networking service network ID.

  * `subnet_id` - (Optional) An OpenStack Networking service subnet ID.

  * `maintenance_window_start` - (Optional) UTC time in "hh:mm:ss" format of when the cluster will start its maintenance tasks.

  * `enable_audit_logs` - Enables or disables collection of audit logs, sent as `kubernetes_options.audit_logs.enabled`. Learn how to [configure export of audit logs to a logging system](https://docs.selectel.ru/en/cloud/managed-kubernetes/clusters/logs/#configure-export-of-audit-logs).

    * `false` (default) - Audit logs are not collected and are not available for export;

    * `true` - Audit logs are collected and available for export.

## Outputs

  * `cluster_id` - ID of the created MKS cluster.

  * `project_id` - ID of the Cloud project of where the cluster is located.

  * `pool` - Cloud pool of where the cluster is located.
