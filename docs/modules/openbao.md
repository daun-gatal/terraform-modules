<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.1.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 3.0.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.1.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 3.0.1 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.openbao](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret.openbao_storage_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.openbao_unseal_keys](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [random_bytes.unseal_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/bytes) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_plugins"></a> [additional\_plugins](#input\_additional\_plugins) | Additional plugins to merge with default plugins. See: https://openbao.org/docs/configuration/plugin/ | <pre>list(object({<br/>    name        = string               # Plugin name (e.g., "aws", "kubernetes")<br/>    image       = string               # OCI image reference<br/>    version     = string               # Plugin version<br/>    binary_name = string               # Binary name in the image<br/>    sha256sum   = optional(string, "") # SHA256 checksum (optional but recommended)<br/>    type        = string<br/>  }))</pre> | `[]` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | OpenBao Helm chart version | `string` | `"0.20.0"` | no |
| <a name="input_disable_default_plugins"></a> [disable\_default\_plugins](#input\_disable\_default\_plugins) | Set to true to disable all default plugins | `bool` | `false` | no |
| <a name="input_generate_unseal_key"></a> [generate\_unseal\_key](#input\_generate\_unseal\_key) | Whether to generate unseal key automatically or use provided key | `bool` | `true` | no |
| <a name="input_openbao_fullname_override"></a> [openbao\_fullname\_override](#input\_openbao\_fullname\_override) | Helm release fullname override | `string` | `"openbao"` | no |
| <a name="input_openbao_namespace"></a> [openbao\_namespace](#input\_openbao\_namespace) | Namespace for OpenBao deployment | `string` | `"openbao"` | no |
| <a name="input_plugin_auto_download"></a> [plugin\_auto\_download](#input\_plugin\_auto\_download) | Enable automatic plugin downloading from OCI images. See: https://openbao.org/docs/configuration/plugin/ | `bool` | `true` | no |
| <a name="input_plugin_auto_register"></a> [plugin\_auto\_register](#input\_plugin\_auto\_register) | Enable automatic plugin registration. See: https://openbao.org/docs/configuration/plugin/ | `bool` | `true` | no |
| <a name="input_plugin_directory"></a> [plugin\_directory](#input\_plugin\_directory) | Directory from which plugins are loaded. See: https://openbao.org/docs/configuration/ | `string` | `"/openbao/plugins"` | no |
| <a name="input_plugin_download_behavior"></a> [plugin\_download\_behavior](#input\_plugin\_download\_behavior) | Plugin download behavior when download fails: fail, warn, or ignore | `string` | `"warn"` | no |
| <a name="input_server_audit_storage"></a> [server\_audit\_storage](#input\_server\_audit\_storage) | Server audit storage (PVC) configuration | <pre>object({<br/>    enabled      = bool<br/>    size         = string<br/>    storageClass = string<br/>  })</pre> | <pre>{<br/>  "enabled": false,<br/>  "size": "5Gi",<br/>  "storageClass": "standard"<br/>}</pre> | no |
| <a name="input_server_data_storage"></a> [server\_data\_storage](#input\_server\_data\_storage) | Server data storage (PVC) configuration | <pre>object({<br/>    enabled      = bool<br/>    size         = string<br/>    storageClass = string<br/>  })</pre> | <pre>{<br/>  "enabled": false,<br/>  "size": "5Gi",<br/>  "storageClass": "standard"<br/>}</pre> | no |
| <a name="input_server_ha_config"></a> [server\_ha\_config](#input\_server\_ha\_config) | HA server config (HCL) - listener configuration only. Storage is managed separately. | `string` | `"ui = true\n\nlistener \"tcp\" {\n  tls_disable     = 1\n  address         = \"[::]:8200\"\n  cluster_address = \"[::]:8201\"\n}\n\nservice_registration \"kubernetes\" {}\n"` | no |
| <a name="input_server_ha_enabled"></a> [server\_ha\_enabled](#input\_server\_ha\_enabled) | Enable HA mode | `bool` | `true` | no |
| <a name="input_server_ha_raft_enabled"></a> [server\_ha\_raft\_enabled](#input\_server\_ha\_raft\_enabled) | Enable Raft storage for HA | `bool` | `false` | no |
| <a name="input_server_ha_raft_set_node_id"></a> [server\_ha\_raft\_set\_node\_id](#input\_server\_ha\_raft\_set\_node\_id) | Set Raft node ID to pod name | `bool` | `false` | no |
| <a name="input_server_ha_replicas"></a> [server\_ha\_replicas](#input\_server\_ha\_replicas) | Number of HA replicas | `number` | `2` | no |
| <a name="input_server_standalone_config"></a> [server\_standalone\_config](#input\_server\_standalone\_config) | Standalone server config (HCL) - listener configuration only. Storage is managed separately. | `string` | `"ui = true\n\nlistener \"tcp\" {\n  tls_disable     = 1\n  address         = \"[::]:8200\"\n  cluster_address = \"[::]:8201\"\n}\n"` | no |
| <a name="input_server_standalone_enabled"></a> [server\_standalone\_enabled](#input\_server\_standalone\_enabled) | Enable standalone mode | `bool` | `false` | no |
| <a name="input_server_storage_secret_name"></a> [server\_storage\_secret\_name](#input\_server\_storage\_secret\_name) | Secret name for server config (config.hcl) | `string` | `"openbao-storage-config"` | no |
| <a name="input_server_unseal_secret_name"></a> [server\_unseal\_secret\_name](#input\_server\_unseal\_secret\_name) | Secret name for unseal keys | `string` | `"openbao-unseal-key"` | no |
| <a name="input_storage_file"></a> [storage\_file](#input\_storage\_file) | File storage backend configuration (development only) | <pre>object({<br/>    path = optional(string, "/openbao/data")<br/>  })</pre> | `{}` | no |
| <a name="input_storage_postgresql"></a> [storage\_postgresql](#input\_storage\_postgresql) | PostgreSQL storage backend configuration. See: https://openbao.org/docs/configuration/storage/postgresql/ | <pre>object({<br/>    connection_url       = string<br/>    table                = optional(string, "openbao_kv_store")<br/>    max_idle_connections = optional(number)<br/>    max_parallel         = optional(number, 128)<br/>    ha_enabled           = optional(bool, false)<br/>    ha_table             = optional(string, "openbao_ha_locks")<br/>    skip_create_table    = optional(bool, false)<br/>    max_connect_retries  = optional(number, 1)<br/>  })</pre> | `null` | no |
| <a name="input_storage_raft"></a> [storage\_raft](#input\_storage\_raft) | Raft (integrated) storage backend configuration. See: https://openbao.org/docs/configuration/storage/raft/ | <pre>object({<br/>    path                         = optional(string, "/openbao/data")<br/>    node_id                      = optional(string)<br/>    performance_multiplier       = optional(number, 0)<br/>    trailing_logs                = optional(number, 10000)<br/>    snapshot_threshold           = optional(number, 8192)<br/>    snapshot_interval            = optional(string, "120s")<br/>    max_entry_size               = optional(number, 1048576)<br/>    max_transaction_size         = optional(number, 8388608)<br/>    autopilot_reconcile_interval = optional(string, "10s")<br/>    autopilot_update_interval    = optional(string, "2s")<br/>    retry_join = optional(list(object({<br/>      leader_api_addr         = optional(string)<br/>      auto_join               = optional(string)<br/>      auto_join_scheme        = optional(string, "https")<br/>      auto_join_port          = optional(number, 8200)<br/>      leader_tls_servername   = optional(string)<br/>      leader_ca_cert_file     = optional(string)<br/>      leader_client_cert_file = optional(string)<br/>      leader_client_key_file  = optional(string)<br/>    })), [])<br/>  })</pre> | `{}` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Storage backend type: postgresql, raft, file | `string` | `"raft"` | no |
| <a name="input_tailscale_server_expose"></a> [tailscale\_server\_expose](#input\_tailscale\_server\_expose) | Expose server service via Tailscale | `string` | `"false"` | no |
| <a name="input_tailscale_ui_expose"></a> [tailscale\_ui\_expose](#input\_tailscale\_ui\_expose) | Expose UI service via Tailscale | `string` | `"false"` | no |
| <a name="input_ui_enabled"></a> [ui\_enabled](#input\_ui\_enabled) | Enable web UI | `bool` | `true` | no |
| <a name="input_ui_external_port"></a> [ui\_external\_port](#input\_ui\_external\_port) | External UI port | `number` | `80` | no |
| <a name="input_unseal_current_key"></a> [unseal\_current\_key](#input\_unseal\_current\_key) | Current unseal key (32 bytes, base64 encoded). Required if generate\_unseal\_key is false | `string` | `""` | no |
| <a name="input_unseal_current_key_id"></a> [unseal\_current\_key\_id](#input\_unseal\_current\_key\_id) | Identifier for the current unseal key (e.g., date-based: 2024-12-17) | `string` | `"initial-key"` | no |
| <a name="input_unseal_previous_key"></a> [unseal\_previous\_key](#input\_unseal\_previous\_key) | Previous unseal key for rotation (32 bytes, base64 encoded). Optional | `string` | `""` | no |
| <a name="input_unseal_previous_key_id"></a> [unseal\_previous\_key\_id](#input\_unseal\_previous\_key\_id) | Identifier for the previous unseal key. Required if unseal\_previous\_key is set | `string` | `""` | no |
| <a name="input_values"></a> [values](#input\_values) | Additional Helm values to merge (supports all chart values). These values will override any defaults. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs. |
| <a name="output_deployment_name"></a> [deployment\_name](#output\_deployment\_name) | Name of the OpenBao deployment |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Namespace where OpenBao is deployed |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Name of the OpenBao active service |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | OpenBao service port |
<!-- END_TF_DOCS -->