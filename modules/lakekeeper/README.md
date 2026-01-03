# Lakekeeper Terraform Module

## Description
Deploys Lakekeeper, a Rust-native Iceberg REST Catalog server.

## Usage

```hcl
module "lakekeeper" {
  source = "git::https://github.com/daun-gatal/terraform-modules.git//modules/lakekeeper?ref=v0.1.0"

  namespace           = "catalog"
  database_host_read  = "postgres-ro.database.svc"
  database_host_write = "postgres-rw.database.svc"
  database_user       = "lakekeeper"
  database_password   = "password"
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
| [helm_release.lakekeeper](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_ingress_v1.lakekeeper_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_secret_v1.lakekeeper_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_catalog_config"></a> [catalog\_config](#input\_catalog\_config) | Configuration options for the catalog (environment variables) | `map(string)` | `{}` | no |
| <a name="input_catalog_replicas"></a> [catalog\_replicas](#input\_catalog\_replicas) | Number of replicas to deploy | `number` | `1` | no |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm chart name | `string` | `"lakekeeper"` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Helm chart repository | `string` | `"https://lakekeeper.github.io/lakekeeper-charts/"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version | `string` | `"0.8.1"` | no |
| <a name="input_database_host_read"></a> [database\_host\_read](#input\_database\_host\_read) | Hostname for read instances of the external database | `string` | `"localhost"` | no |
| <a name="input_database_host_write"></a> [database\_host\_write](#input\_database\_host\_write) | Hostname for write instances of the external database | `string` | `"localhost"` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Database name | `string` | `"catalog"` | no |
| <a name="input_database_password"></a> [database\_password](#input\_database\_password) | Database password | `string` | `""` | no |
| <a name="input_database_port"></a> [database\_port](#input\_database\_port) | Port of the external database | `number` | `5432` | no |
| <a name="input_database_type"></a> [database\_type](#input\_database\_type) | Type of external database (postgres) | `string` | `"postgres"` | no |
| <a name="input_database_user"></a> [database\_user](#input\_database\_user) | Database user | `string` | `"catalog"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Lakekeeper deployment | `string` | `"lakekeeper"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for resource names | `string` | `"lakekeeper"` | no |
| <a name="input_resources_config"></a> [resources\_config](#input\_resources\_config) | Resource requests/limits per component | <pre>map(object({<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose service via Tailscale | `bool` | `false` | no |
| <a name="input_tailscale_funnel"></a> [tailscale\_funnel](#input\_tailscale\_funnel) | Expose service via Tailscale Funnel (public ingress) | `bool` | `false` | no |
| <a name="input_values"></a> [values](#input\_values) | Additional Helm values to merge | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_internal_dns"></a> [internal\_dns](#output\_internal\_dns) | Internal DNS of the Lakekeeper service |
| <a name="output_port"></a> [port](#output\_port) | Port of the Lakekeeper service |
<!-- END_TF_DOCS -->