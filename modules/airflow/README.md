<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.16 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.16 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.30.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.airflow_chart](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret.airflow_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_airflow_api_secret_key"></a> [airflow\_api\_secret\_key](#input\_airflow\_api\_secret\_key) | API secret key | `string` | n/a | yes |
| <a name="input_airflow_api_server_config"></a> [airflow\_api\_server\_config](#input\_airflow\_api\_server\_config) | Additional API server configuration options | `string` | `""` | no |
| <a name="input_airflow_dag_processor_enabled"></a> [airflow\_dag\_processor\_enabled](#input\_airflow\_dag\_processor\_enabled) | Enable DAG processor | `bool` | `true` | no |
| <a name="input_airflow_dag_processor_replicas"></a> [airflow\_dag\_processor\_replicas](#input\_airflow\_dag\_processor\_replicas) | Number of DAG processor replicas | `number` | `1` | no |
| <a name="input_airflow_dags_git_sync_branch"></a> [airflow\_dags\_git\_sync\_branch](#input\_airflow\_dags\_git\_sync\_branch) | Git branch to sync | `string` | `"main"` | no |
| <a name="input_airflow_dags_git_sync_enabled"></a> [airflow\_dags\_git\_sync\_enabled](#input\_airflow\_dags\_git\_sync\_enabled) | Enable git-sync for DAGs | `bool` | `true` | no |
| <a name="input_airflow_dags_git_sync_ref"></a> [airflow\_dags\_git\_sync\_ref](#input\_airflow\_dags\_git\_sync\_ref) | Git reference to sync | `string` | `""` | no |
| <a name="input_airflow_dags_git_sync_repo"></a> [airflow\_dags\_git\_sync\_repo](#input\_airflow\_dags\_git\_sync\_repo) | Git repository URL for DAGs | `string` | n/a | yes |
| <a name="input_airflow_dags_git_sync_rev"></a> [airflow\_dags\_git\_sync\_rev](#input\_airflow\_dags\_git\_sync\_rev) | Git revision to sync | `string` | `"HEAD"` | no |
| <a name="input_airflow_dags_git_sync_subpath"></a> [airflow\_dags\_git\_sync\_subpath](#input\_airflow\_dags\_git\_sync\_subpath) | Subpath within DAGs repo | `string` | `""` | no |
| <a name="input_airflow_default_password"></a> [airflow\_default\_password](#input\_airflow\_default\_password) | Default webserver password | `string` | n/a | yes |
| <a name="input_airflow_enable_triggerer"></a> [airflow\_enable\_triggerer](#input\_airflow\_enable\_triggerer) | Enable triggerer component | `bool` | `false` | no |
| <a name="input_airflow_executor"></a> [airflow\_executor](#input\_airflow\_executor) | Executor type (CeleryExecutor or KubernetesExecutor) | `string` | `"KubernetesExecutor"` | no |
| <a name="input_airflow_fernet_key"></a> [airflow\_fernet\_key](#input\_airflow\_fernet\_key) | Fernet key for secrets encryption | `string` | n/a | yes |
| <a name="input_airflow_flower_credential"></a> [airflow\_flower\_credential](#input\_airflow\_flower\_credential) | Flower UI credentials (user:pass) | `string` | `"admin:admin"` | no |
| <a name="input_airflow_flower_enabled"></a> [airflow\_flower\_enabled](#input\_airflow\_flower\_enabled) | Enable Flower monitoring UI | `bool` | `false` | no |
| <a name="input_airflow_kubernetes_cleanup_enabled"></a> [airflow\_kubernetes\_cleanup\_enabled](#input\_airflow\_kubernetes\_cleanup\_enabled) | Enable Kubernetes pod cleanup job | `bool` | `false` | no |
| <a name="input_airflow_log_retention_days"></a> [airflow\_log\_retention\_days](#input\_airflow\_log\_retention\_days) | Log retention period in days | `number` | `7` | no |
| <a name="input_airflow_logs_bucket_name"></a> [airflow\_logs\_bucket\_name](#input\_airflow\_logs\_bucket\_name) | S3 bucket name for remote logs | `string` | `null` | no |
| <a name="input_airflow_metadata_db_conn"></a> [airflow\_metadata\_db\_conn](#input\_airflow\_metadata\_db\_conn) | SQLAlchemy connection string (postgresql://user:pass@host:port/db) | `string` | n/a | yes |
| <a name="input_airflow_resources_config"></a> [airflow\_resources\_config](#input\_airflow\_resources\_config) | Resource requests/limits per component. Empty by default - no resources applied to avoid CPU issues on k3s. | <pre>map(object({<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_airflow_scheduler_replicas"></a> [airflow\_scheduler\_replicas](#input\_airflow\_scheduler\_replicas) | Number of scheduler replicas | `number` | `1` | no |
| <a name="input_airflow_triggerer_replicas"></a> [airflow\_triggerer\_replicas](#input\_airflow\_triggerer\_replicas) | Number of triggerer replicas | `number` | `1` | no |
| <a name="input_airflow_worker_keda_enabled"></a> [airflow\_worker\_keda\_enabled](#input\_airflow\_worker\_keda\_enabled) | Enable KEDA autoscaling for workers | `bool` | `false` | no |
| <a name="input_airflow_worker_keda_max_replicas"></a> [airflow\_worker\_keda\_max\_replicas](#input\_airflow\_worker\_keda\_max\_replicas) | Max worker replicas with KEDA | `number` | `3` | no |
| <a name="input_airflow_worker_keda_min_replicas"></a> [airflow\_worker\_keda\_min\_replicas](#input\_airflow\_worker\_keda\_min\_replicas) | Min worker replicas with KEDA | `number` | `0` | no |
| <a name="input_airflow_worker_replicas"></a> [airflow\_worker\_replicas](#input\_airflow\_worker\_replicas) | Number of worker replicas | `number` | `1` | no |
| <a name="input_aws_access_key_id"></a> [aws\_access\_key\_id](#input\_aws\_access\_key\_id) | AWS access key ID | `string` | `""` | no |
| <a name="input_aws_endpoint_url"></a> [aws\_endpoint\_url](#input\_aws\_endpoint\_url) | Custom S3 endpoint URL (for MinIO/S3-compatible storage) | `string` | `""` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region (e.g., us-east-1) | `string` | `"us-east-1"` | no |
| <a name="input_aws_secret_access_key"></a> [aws\_secret\_access\_key](#input\_aws\_secret\_access\_key) | AWS secret access key | `string` | `""` | no |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm chart name | `string` | `"airflow"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version | `string` | `"1.18.0"` | no |
| <a name="input_enable_log_groomer_sidecar"></a> [enable\_log\_groomer\_sidecar](#input\_enable\_log\_groomer\_sidecar) | Enable log groomer sidecar | `bool` | `false` | no |
| <a name="input_enable_remote_logging"></a> [enable\_remote\_logging](#input\_enable\_remote\_logging) | Enable remote logging to S3 | `bool` | `false` | no |
| <a name="input_enable_statsd"></a> [enable\_statsd](#input\_enable\_statsd) | Enable StatsD metrics | `bool` | `false` | no |
| <a name="input_git_auth_method"></a> [git\_auth\_method](#input\_git\_auth\_method) | Git auth method (ssh or pat) | `string` | `"ssh"` | no |
| <a name="input_git_password"></a> [git\_password](#input\_git\_password) | Git password or PAT (required for pat auth) | `string` | `null` | no |
| <a name="input_git_ssh_key_path"></a> [git\_ssh\_key\_path](#input\_git\_ssh\_key\_path) | Path to SSH key file (required for ssh auth) | `string` | `null` | no |
| <a name="input_git_username"></a> [git\_username](#input\_git\_username) | Git username (required for pat auth) | `string` | `null` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Container image repository | `string` | `"apache/airflow"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Container image tag | `string` | `"3.0.6"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Airflow deployment | `string` | `"airflow"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for resource names | `string` | `"airflow"` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose service via Tailscale | `bool` | `false` | no |
| <a name="input_values"></a> [values](#input\_values) | Additional Helm values to merge (supports all chart values). These values will override any defaults. | `any` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->