# Superset Terraform Module

## Description
Deploys Apache Superset, a modern data exploration and visualization platform.

## Usage

```hcl
module "superset" {
  source = "git::https://github.com/daun-gatal/terraform-modules.git//modules/superset?ref=v0.1.0"

  namespace      = "analytics"
  admin_password = "secure-password"
  superset_secret_name = "my-superset-secret"
  
  use_external_database = true
  use_external_redis    = true
}
```

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
| [helm_release.superset](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_ingress_v1.superset_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_email"></a> [admin\_email](#input\_admin\_email) | Admin email address | `string` | `"admin@superset.com"` | no |
| <a name="input_admin_firstname"></a> [admin\_firstname](#input\_admin\_firstname) | Admin first name | `string` | `"Admin"` | no |
| <a name="input_admin_lastname"></a> [admin\_lastname](#input\_admin\_lastname) | Admin last name | `string` | `"User"` | no |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Admin password | `string` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Admin username | `string` | `"admin"` | no |
| <a name="input_bootstrap_pip_packages"></a> [bootstrap\_pip\_packages](#input\_bootstrap\_pip\_packages) | List of pip packages to install during bootstrap (e.g., database drivers, connectors) | `list(string)` | `[]` | no |
| <a name="input_celery_worker_replicas"></a> [celery\_worker\_replicas](#input\_celery\_worker\_replicas) | Number of Celery worker replicas | `number` | `1` | no |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm chart name | `string` | `"superset"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version | `string` | `"0.14.1"` | no |
| <a name="input_enable_celery_beat"></a> [enable\_celery\_beat](#input\_enable\_celery\_beat) | Enable Celery beat scheduler | `bool` | `false` | no |
| <a name="input_enable_celery_flower"></a> [enable\_celery\_flower](#input\_enable\_celery\_flower) | Enable Celery Flower monitoring UI | `bool` | `false` | no |
| <a name="input_enable_celery_worker"></a> [enable\_celery\_worker](#input\_enable\_celery\_worker) | Enable Celery worker for async queries | `bool` | `false` | no |
| <a name="input_enable_superset_autoscaling"></a> [enable\_superset\_autoscaling](#input\_enable\_superset\_autoscaling) | Enable autoscaling for Superset web server and Celery worker | `bool` | `false` | no |
| <a name="input_enable_websockets"></a> [enable\_websockets](#input\_enable\_websockets) | Enable websocket server for real-time features | `bool` | `false` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | Container image pull policy | `string` | `"IfNotPresent"` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Container image repository | `string` | `"apachesuperset.docker.scarf.sh/apache/superset"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Container image tag | `string` | `"5.0.0"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Superset deployment | `string` | `"superset"` | no |
| <a name="input_oauth_config"></a> [oauth\_config](#input\_oauth\_config) | OAuth configuration for Superset authentication | `string` | `""` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for resource names | `string` | `"superset"` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | Kubernetes service type | `string` | `"ClusterIP"` | no |
| <a name="input_superset_autoscaling_max_replicas"></a> [superset\_autoscaling\_max\_replicas](#input\_superset\_autoscaling\_max\_replicas) | Maximum number of replicas for autoscaling | `number` | `2` | no |
| <a name="input_superset_autoscaling_min_replicas"></a> [superset\_autoscaling\_min\_replicas](#input\_superset\_autoscaling\_min\_replicas) | Minimum number of replicas for autoscaling | `number` | `1` | no |
| <a name="input_superset_autoscaling_target_cpu_utilization_percentage"></a> [superset\_autoscaling\_target\_cpu\_utilization\_percentage](#input\_superset\_autoscaling\_target\_cpu\_utilization\_percentage) | Target CPU utilization percentage for autoscaling | `number` | `90` | no |
| <a name="input_superset_autoscaling_target_memory_utilization_percentage"></a> [superset\_autoscaling\_target\_memory\_utilization\_percentage](#input\_superset\_autoscaling\_target\_memory\_utilization\_percentage) | Target Memory utilization percentage for autoscaling | `number` | `90` | no |
| <a name="input_superset_node_replicas"></a> [superset\_node\_replicas](#input\_superset\_node\_replicas) | Number of Superset web server replicas | `number` | `1` | no |
| <a name="input_superset_port"></a> [superset\_port](#input\_superset\_port) | Port for Superset service | `number` | `8088` | no |
| <a name="input_superset_resources_config"></a> [superset\_resources\_config](#input\_superset\_resources\_config) | Resource requests/limits per component. Empty by default - no resources applied to avoid CPU issues on k3s. | <pre>map(object({<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_superset_secret_name"></a> [superset\_secret\_name](#input\_superset\_secret\_name) | Name of an existing Kubernetes Secret for Superset. The secret must contain the following env vars: DB\_HOST, DB\_PORT, DB\_NAME, DB\_USER, DB\_PASS, REDIS\_HOST, REDIS\_PORT, REDIS\_PROTO, SUPERSET\_SECRET\_KEY. | `string` | `"superset-custom-secret"` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose service via Tailscale | `bool` | `false` | no |
| <a name="input_tailscale_funnel"></a> [tailscale\_funnel](#input\_tailscale\_funnel) | Enable Tailscale Funnel for the Superset service | `bool` | `false` | no |
| <a name="input_use_external_database"></a> [use\_external\_database](#input\_use\_external\_database) | Use external PostgreSQL instead of built-in | `bool` | `false` | no |
| <a name="input_use_external_redis"></a> [use\_external\_redis](#input\_use\_external\_redis) | Use external Redis instead of built-in | `bool` | `false` | no |
| <a name="input_values"></a> [values](#input\_values) | Additional Helm values to merge (supports all chart values). These values will override any defaults. | `any` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->