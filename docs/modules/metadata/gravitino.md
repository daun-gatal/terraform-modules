# Gravitino

Unified metadata catalog for data platforms. This module deploys Gravitino components.

::: code-group

## Overview

Manage metadata across different storage and processing systems with a unified catalog.

## Server

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.3 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.1.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 3.0.1 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | ~> 2.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.1.1 |

### Resources

| Name | Type |
|------|------|
| [helm_release.gravitino](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [external_external.fetch_charts](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_entity_jdbc_config"></a> [entity\_jdbc\_config](#input\_entity\_jdbc\_config) | External JDBC configuration for entity store | `object` | `null` | no |
| <a name="input_gravitino_version"></a> [gravitino\_version](#input\_gravitino\_version) | Gravitino version to download | `string` | `"v1.0.1"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Docker image tag | `string` | `"1.0.1"` | no |
| <a name="input_mysql_enabled"></a> [mysql\_enabled](#input\_mysql\_enabled) | Enable built-in MySQL deployment | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace | `string` | `"gravitino"` | no |
| <a name="input_postgresql_enabled"></a> [postgresql\_enabled](#input\_postgresql\_enabled) | Enable built-in PostgreSQL deployment | `bool` | `false` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Helm release name | `string` | `"gravitino"` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of replicas | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Container resource requests and limits. | `object` | `null` | no |
| <a name="input_service_annotations"></a> [service\_annotations](#input\_service\_annotations) | Service annotations | `map(string)` | `{}` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | Service type | `string` | `"ClusterIP"` | no |
| <a name="input_values"></a> [values](#input\_values) | Additional Helm values | `any` | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace where the service is deployed |
| <a name="output_release_name"></a> [release\_name](#output\_release\_name) | The name of the Helm release |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The name of the service |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | The port of the service |
<!-- END_TF_DOCS -->

## Iceberg REST

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.3 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.1.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 3.0.1 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | ~> 2.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.1.1 |

### Resources

| Name | Type |
|------|------|
| [helm_release.iceberg_rest](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [external_external.fetch_charts](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_catalog_backend"></a> [catalog\_backend](#input\_catalog\_backend) | Iceberg catalog backend (memory, hive, jdbc) | `string` | `"memory"` | no |
| <a name="input_gravitino_version"></a> [gravitino\_version](#input\_gravitino\_version) | Gravitino version | `string` | `"v1.0.1"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Docker image tag | `string` | `"1.0.1"` | no |
| <a name="input_io_impl"></a> [io\_impl](#input\_io\_impl) | Iceberg FileIO implementation | `string` | `null` | no |
| <a name="input_jdbc_config"></a> [jdbc\_config](#input\_jdbc\_config) | JDBC configuration for catalog backend | `object` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace | `string` | `"gravitino"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Helm release name | `string` | `"gravitino-iceberg-rest"` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of replicas | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Container resource requests and limits. | `object` | `null` | no |
| <a name="input_s3_config"></a> [s3\_config](#input\_s3\_config) | S3 storage configuration | `object` | `null` | no |
| <a name="input_service_annotations"></a> [service\_annotations](#input\_service\_annotations) | Service annotations | `map(string)` | `{}` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | Service type | `string` | `"ClusterIP"` | no |
| <a name="input_values"></a> [values](#input\_values) | Additional Helm values | `any` | `{}` | no |
| <a name="input_warehouse"></a> [warehouse](#input\_warehouse) | Iceberg warehouse location | `string` | `"/tmp/"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace where the service is deployed |
| <a name="output_release_name"></a> [release\_name](#output\_release\_name) | The name of the Helm release |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The name of the service |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | The port of the service |
<!-- END_TF_DOCS -->

:::