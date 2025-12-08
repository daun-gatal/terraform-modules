locals {
  # Default values - structured like rustfs pattern
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
            "tailscale.com/expose"   = var.tailscale_expose
            "tailscale.com/hostname" = "openbao-server-int"
          }
        }
      }

      dataStorage  = var.server_data_storage
      auditStorage = var.server_audit_storage

      volumes = [
        {
          name = "userconfig-openbao-storage-config"
          secret = {
            secretName  = data.kubernetes_secret.openbao_storage_config.metadata[0].name
            defaultMode = 420
          }
        },
        {
          name = "unseal-keys"
          secret = {
            secretName  = data.kubernetes_secret.openbao_unseal_keys.metadata[0].name
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
        "tailscale.com/expose"   = var.tailscale_expose
        "tailscale.com/hostname" = "openbao-web-int"
      }
    }
  }

  # Merge default values with user-provided values
  merged_values = merge(local.default_values, var.values)
}

# -------------------------------
# Data Sources
# -------------------------------
data "kubernetes_secret" "openbao_unseal_keys" {
  metadata {
    name      = var.server_unseal_secret_name
    namespace = var.openbao_namespace
  }
}

data "kubernetes_secret" "openbao_storage_config" {
  depends_on = [data.kubernetes_secret.openbao_unseal_keys]

  metadata {
    name      = var.server_storage_secret_name
    namespace = var.openbao_namespace
  }
}

# -------------------------------
# Helm Release
# -------------------------------
resource "helm_release" "openbao" {
  depends_on = [data.kubernetes_secret.openbao_storage_config]

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
