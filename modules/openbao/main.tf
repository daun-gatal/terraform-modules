# -------------------------------
# Check if OpenBao storage secret exists
# -------------------------------
data "kubernetes_secret" "openbao_storage_config" {
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
  create_namespace = true

  values = [
    yamlencode({
      fullnameOverride = var.openbao_fullname_override

      global = {
        enabled   = true
        namespace = var.openbao_namespace
      }

      server = {
        # resources = var.server_resources

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
          }
        ]

        volumeMounts = [
          {
            mountPath = "/openbao/userconfig/openbao-storage-config"
            name      = "userconfig-openbao-storage-config"
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

      ui = {
        enabled      = var.ui_enabled
        externalPort = var.ui_external_port
        annotations = {
          "tailscale.com/expose"   = var.tailscale_expose
          "tailscale.com/hostname" = "openbao-web-int"
        }
      }
    })
  ]
}
