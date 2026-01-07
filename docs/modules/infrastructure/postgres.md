<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.3 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 3.0.1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 3.0.1 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_manifest.extra_postgres_databases](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.postgres_cluster](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_secret.postgres_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [null_resource.postgres_config](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Database name | `string` | `"postgres"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Database password | `string` | n/a | yes |
| <a name="input_db_port"></a> [db\_port](#input\_db\_port) | Database port | `number` | `5432` | no |
| <a name="input_db_user"></a> [db\_user](#input\_db\_user) | Database username | `string` | `"dev"` | no |
| <a name="input_extra_db_names"></a> [extra\_db\_names](#input\_extra\_db\_names) | Additional databases to create | `list(string)` | `[]` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Container image repository | `string` | `"ghcr.io/cloudnative-pg/postgresql"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Container image tag | `string` | `"15.4"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for PostgreSQL deployment | `string` | `"database"` | no |
| <a name="input_postgres_replicas"></a> [postgres\_replicas](#input\_postgres\_replicas) | Number of instances (1=single, 3+=HA) | `number` | `1` | no |
| <a name="input_postgres_resources_config"></a> [postgres\_resources\_config](#input\_postgres\_resources\_config) | Resource requests/limits. Empty by default - no resources applied to avoid CPU issues on k3s. | <pre>object({<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_postgresql_parameters"></a> [postgresql\_parameters](#input\_postgresql\_parameters) | Additional PostgreSQL config parameters | `map(string)` | <pre>{<br/>  "max_connections": "300"<br/>}</pre> | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for resource names | `string` | `"postgres"` | no |
| <a name="input_storage_class_name"></a> [storage\_class\_name](#input\_storage\_class\_name) | Storage class for persistent volumes | `string` | `"standard"` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Persistent volume size | `string` | `"10Gi"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace where Postgres is deployed |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | PostgreSQL read-write service name (primary) |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | The port of the Postgres service |
<!-- END_TF_DOCS -->