<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.3 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 3.0.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 3.0.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.hms_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_deployment.metastore](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_service.metastore](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_jars"></a> [additional\_jars](#input\_additional\_jars) | Map of filename to URL for additional JARs to download in the init container. Defaults include AWS SDK and Hadoop AWS. | `map(string)` | <pre>{<br/>  "aws-java-sdk-bundle-1.11.271.jar": "https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.271/aws-java-sdk-bundle-1.11.271.jar",<br/>  "guava-27.0-jre.jar": "https://repo1.maven.org/maven2/com/google/guava/guava/27.0-jre/guava-27.0-jre.jar",<br/>  "hadoop-aws-3.1.3.jar": "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.1.3/hadoop-aws-3.1.3.jar",<br/>  "postgresql-42.7.3.jar": "https://jdbc.postgresql.org/download/postgresql-42.7.3.jar"<br/>}</pre> | no |
| <a name="input_database_host"></a> [database\_host](#input\_database\_host) | PostgreSQL host | `string` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | PostgreSQL database name | `string` | `"metastore"` | no |
| <a name="input_database_password"></a> [database\_password](#input\_database\_password) | PostgreSQL password | `string` | n/a | yes |
| <a name="input_database_port"></a> [database\_port](#input\_database\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_database_user"></a> [database\_user](#input\_database\_user) | PostgreSQL user | `string` | n/a | yes |
| <a name="input_extra_env_vars"></a> [extra\_env\_vars](#input\_extra\_env\_vars) | Map of extra environment variables | `map(string)` | `{}` | no |
| <a name="input_hive_metastore_warehouse_dir"></a> [hive\_metastore\_warehouse\_dir](#input\_hive\_metastore\_warehouse\_dir) | Hive Metastore warehouse directory (e.g. s3a://bucket/warehouse) | `string` | `"s3a://datalake/warehouse"` | no |
| <a name="input_hive_site_config"></a> [hive\_site\_config](#input\_hive\_site\_config) | Additional configuration properties for hive-site.xml | `map(string)` | <pre>{<br/>  "datanucleus.schema.autoCreateAll": "false",<br/>  "fs.s3a.aws.credentials.provider": "org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider",<br/>  "fs.s3a.connection.ssl.enabled": "false",<br/>  "fs.s3a.endpoint.region": "us-east-1",<br/>  "fs.s3a.impl": "org.apache.hadoop.fs.s3a.S3AFileSystem",<br/>  "fs.s3a.path.style.access": "true",<br/>  "hive.warehouse.subdir.inherit.perms": "true",<br/>  "javax.jdo.option.ConnectionDriverName": "org.postgresql.Driver"<br/>}</pre> | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | Image pull policy | `string` | `"IfNotPresent"` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Container image repository | `string` | `"apache/hive"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Container image tag | `string` | `"3.1.3"` | no |
| <a name="input_metastore_replicas"></a> [metastore\_replicas](#input\_metastore\_replicas) | Number of Metastore replicas | `number` | `1` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for HMS deployment | `string` | `"hms"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for resource names | `string` | `"hms"` | no |
| <a name="input_resources_config"></a> [resources\_config](#input\_resources\_config) | Resource requests/limits per component | <pre>object({<br/>    metastore = optional(object({<br/>      requests = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }))<br/>      limits = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }))<br/>    }))<br/>  })</pre> | `{}` | no |
| <a name="input_s3_access_key"></a> [s3\_access\_key](#input\_s3\_access\_key) | S3 access key | `string` | `""` | no |
| <a name="input_s3_endpoint"></a> [s3\_endpoint](#input\_s3\_endpoint) | S3 endpoint URL | `string` | `""` | no |
| <a name="input_s3_secret_key"></a> [s3\_secret\_key](#input\_s3\_secret\_key) | S3 secret key | `string` | `""` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose service via Tailscale | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object containing the internal URL and module-specific attributes. |
| <a name="output_ingress_host"></a> [ingress\_host](#output\_ingress\_host) | The external hostname of HMS (if Ingress is enabled) |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace where HMS is deployed |
| <a name="output_resource_name"></a> [resource\_name](#output\_resource\_name) | The name of the main resource (Metastore) |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The name of the HMS service |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | The port of the HMS service |
<!-- END_TF_DOCS -->