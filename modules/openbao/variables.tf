# ===============================================
# OpenBao Helm Chart Terraform Variables
# ===============================================

# -------------------------------
# General / Global Variables
# -------------------------------

variable "openbao_fullname_override" {
  type        = string
  default     = "openbao"
  description = "Override for the fullname of the Helm release"
}

variable "openbao_namespace" {
  type        = string
  default     = "openbao"
  description = "Namespace to deploy OpenBao"
}

# -------------------------------
# Tailscale Variable
# -------------------------------

variable "tailscale_expose" {
  type        = string
  default     = "false"
  description = "Set the Tailscale expose annotation for services"
}

# -------------------------------
# OpenBao Secret Variable
# -------------------------------

variable "server_storage_secret_name" {
  type        = string
  default     = "openbao-storage-config"
  description = "Name of the Kubernetes secret containing OpenBao server config (config.hcl). Check on this https://openbao.org/docs/platform/k8s/helm/run/#protecting-sensitive-openbao-configurations for more details."
}

# -------------------------------
# OpenBao Server Variables
# -------------------------------

# variable "server_resources" {
#   type        = map(any)
#   default     = {}
#   description = "Resource limits/requests for OpenBao server pods"
# }

variable "server_data_storage" {
  type = object({
    enabled      = bool
    size         = string
    storageClass = string
  })
  default = {
    enabled      = false
    size         = "5Gi"
    storageClass = "standard"
  }
  description = "Configuration for server data storage"
}

variable "server_audit_storage" {
  type = object({
    enabled      = bool
    size         = string
    storageClass = string
  })
  default = {
    enabled      = false
    size         = "5Gi"
    storageClass = "standard"
  }
  description = "Configuration for server audit storage"
}

variable "server_standalone_enabled" {
  type        = bool
  default     = false
  description = "Enable standalone mode for OpenBao server"
}

variable "server_standalone_config" {
  type        = string
  default     = <<-EOT
    ui = true

    listener "tcp" {
      tls_disable     = 1
      address         = "[::]:8200"
      cluster_address = "[::]:8201"
    }
  EOT
  description = "Standalone server configuration (HCL format)"
}

variable "server_ha_enabled" {
  type        = bool
  default     = true
  description = "Enable HA mode for OpenBao server"
}

variable "server_ha_replicas" {
  type        = number
  default     = 2
  description = "Number of replicas in HA mode"
}

variable "server_ha_raft_enabled" {
  type        = bool
  default     = false
  description = "Enable Raft integrated storage for HA"
}

variable "server_ha_raft_set_node_id" {
  type        = bool
  default     = false
  description = "Set Node Raft ID to pod name"
}

variable "server_ha_config" {
  type        = string
  default     = <<-EOT
    ui = true

    listener "tcp" {
      tls_disable     = 1
      address         = "[::]:8200"
      cluster_address = "[::]:8201"
    }

    service_registration "kubernetes" {}
  EOT
  description = "HA server configuration (HCL format)"
}

# -------------------------------
# OpenBao UI Variables
# -------------------------------

variable "ui_enabled" {
  type        = bool
  default     = true
  description = "Enable OpenBao UI"
}

variable "ui_external_port" {
  type        = number
  default     = 80
  description = "External port for OpenBao UI"
}
