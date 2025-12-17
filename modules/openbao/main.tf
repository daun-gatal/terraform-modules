# ============================================
# Unseal Key Generation
# ============================================

resource "random_bytes" "unseal_key" {
  count  = var.generate_unseal_key ? 1 : 0
  length = 32

  lifecycle {
    prevent_destroy = true
  }
}

# ============================================
# Locals
# ============================================

locals {
  # Use generated key or provided key
  current_unseal_key = var.generate_unseal_key ? random_bytes.unseal_key[0].base64 : var.unseal_current_key

  # Storage config defaults based on type
  postgresql_defaults = {
    connection_url       = ""
    table                = "openbao_kv_store"
    max_idle_connections = null
    max_parallel         = 128
    ha_enabled           = false
    ha_table             = "openbao_ha_locks"
    skip_create_table    = false
    max_connect_retries  = 1
  }

  raft_defaults = {
    path                         = "/openbao/data"
    node_id                      = null
    performance_multiplier       = 0
    trailing_logs                = 10000
    snapshot_threshold           = 8192
    snapshot_interval            = "120s"
    max_entry_size               = 1048576
    max_transaction_size         = 8388608
    autopilot_reconcile_interval = "10s"
    autopilot_update_interval    = "2s"
    retry_join                   = []
  }

  file_defaults = {
    path = "/openbao/data"
  }

  # Merge default plugins with additional plugins
  # Additional plugins with the same binary_name will override default plugins
  merged_plugins = concat(
    var.disable_default_plugins ? [] : [for p in local.default_plugins : p if !contains([for ap in var.additional_plugins : ap.binary_name], p.binary_name)],
    var.additional_plugins
  )

  # Storage config template variables
  storage_template_vars = {
    storage_type     = var.storage_type
    current_key_id   = var.unseal_current_key_id
    has_previous_key = var.unseal_previous_key != ""
    previous_key_id  = var.unseal_previous_key_id

    # PostgreSQL config (merge with defaults)
    postgresql = var.storage_type == "postgresql" && var.storage_postgresql != null ? var.storage_postgresql : local.postgresql_defaults

    # Raft config (merge with defaults)
    raft = var.storage_type == "raft" ? merge(local.raft_defaults, var.storage_raft) : local.raft_defaults

    # File config
    file_storage = var.storage_type == "file" ? merge(local.file_defaults, var.storage_file) : local.file_defaults

    # Plugin configuration
    plugin_directory         = var.plugin_directory
    plugin_auto_download     = var.plugin_auto_download
    plugin_auto_register     = var.plugin_auto_register
    plugin_download_behavior = var.plugin_download_behavior
    plugins                  = local.merged_plugins
  }

  # Render the storage config HCL
  storage_config_hcl = templatefile(
    "${path.module}/templates/config.hcl.tpl",
    local.storage_template_vars
  )

  # Default Helm values
  default_values = {
    # Fullname override
    fullnameOverride = var.openbao_fullname_override

    # Global configuration
    global = {
      enabled   = true
      namespace = var.openbao_namespace
    }

    # Server configuration
    server = {
      service = {
        active = {
          annotations = {
            "tailscale.com/expose"   = var.tailscale_server_expose
            "tailscale.com/hostname" = "${var.openbao_fullname_override}-server-int"
          }
        }
      }

      dataStorage  = var.server_data_storage
      auditStorage = var.server_audit_storage

      volumes = [
        {
          name = "userconfig-openbao-storage-config"
          secret = {
            secretName  = kubernetes_secret.openbao_storage_config.metadata[0].name
            defaultMode = 420
          }
        },
        {
          name = "unseal-keys"
          secret = {
            secretName  = kubernetes_secret.openbao_unseal_keys.metadata[0].name
            defaultMode = 420
          }
        }
      ]

      volumeMounts = [
        {
          mountPath = "/openbao/userconfig/openbao-storage-config"
          name      = "userconfig-openbao-storage-config"
          readOnly  = true
        },
        {
          mountPath = "/openbao/secrets"
          name      = "unseal-keys"
          readOnly  = true
        }
      ]

      extraArgs = "-config=/openbao/userconfig/openbao-storage-config/config.hcl"

      standalone = {
        enabled = var.server_standalone_enabled
        config  = var.server_standalone_config
      }

      ha = {
        enabled  = var.server_ha_enabled
        replicas = var.server_ha_replicas
        raft = {
          enabled   = var.server_ha_raft_enabled
          setNodeId = var.server_ha_raft_set_node_id
        }
        config = var.server_ha_config
      }
    }

    # UI configuration
    ui = {
      enabled      = var.ui_enabled
      externalPort = var.ui_external_port
      annotations = {
        "tailscale.com/expose"   = var.tailscale_ui_expose
        "tailscale.com/hostname" = "${var.openbao_fullname_override}-ui-int"
      }
    }
  }

  # Merge default values with user-provided values
  merged_values = merge(local.default_values, var.values)
}

# ============================================
# Kubernetes Secrets
# ============================================

resource "kubernetes_secret" "openbao_unseal_keys" {
  metadata {
    name      = var.server_unseal_secret_name
    namespace = var.openbao_namespace
  }

  binary_data = merge(
    {
      "unseal-current.key" = local.current_unseal_key
    },
    var.unseal_previous_key != "" ? {
      "unseal-previous.key" = var.unseal_previous_key
    } : {}
  )

  type = "Opaque"
}

resource "kubernetes_secret" "openbao_storage_config" {
  depends_on = [kubernetes_secret.openbao_unseal_keys]

  metadata {
    name      = var.server_storage_secret_name
    namespace = var.openbao_namespace
  }

  data = {
    "config.hcl" = local.storage_config_hcl
  }

  type = "Opaque"
}

# ============================================
# Helm Release
# ============================================

resource "helm_release" "openbao" {
  depends_on = [kubernetes_secret.openbao_storage_config]

  name             = var.openbao_fullname_override
  namespace        = var.openbao_namespace
  repository       = "https://openbao.github.io/openbao-helm"
  chart            = "openbao"
  version          = var.chart_version
  create_namespace = true

  values = [
    yamlencode(local.merged_values)
  ]
}
