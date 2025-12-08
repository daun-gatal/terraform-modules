# ============================================
# Core Configuration
# ============================================

variable "openbao_fullname_override" {
  description = "Helm release fullname override"
  type        = string
  default     = "openbao"
}

variable "openbao_namespace" {
  description = "Namespace for OpenBao deployment"
  type        = string
  default     = "openbao"
}

variable "chart_version" {
  description = "OpenBao Helm chart version"
  type        = string
  default     = "0.20.0"
}

# ============================================
# Service Configuration
# ============================================

variable "tailscale_expose" {
  description = "Expose service via Tailscale"
  type        = string
  default     = "false"
}

# ============================================
# Secrets Configuration
# ============================================

variable "server_storage_secret_name" {
  description = "Secret name for server config (config.hcl)"
  type        = string
  default     = "openbao-storage-config"
}

variable "server_unseal_secret_name" {
  description = "Secret name for unseal keys"
  type        = string
  default     = "openbao-unseal-key"
}

# ============================================
# Server Storage Configuration
# ============================================

variable "server_data_storage" {
  description = "Server data storage configuration"
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
}

variable "server_audit_storage" {
  description = "Server audit storage configuration"
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
}

# ============================================
# Standalone Mode Configuration
# ============================================

variable "server_standalone_enabled" {
  description = "Enable standalone mode"
  type        = bool
  default     = false
}

variable "server_standalone_config" {
  description = "Standalone server config (HCL)"
  type        = string
  default     = <<-EOT
    ui = true

    listener "tcp" {
      tls_disable     = 1
      address         = "[::]:8200"
      cluster_address = "[::]:8201"
    }
  EOT
}

# ============================================
# High Availability Mode Configuration
# ============================================

variable "server_ha_enabled" {
  description = "Enable HA mode"
  type        = bool
  default     = true
}

variable "server_ha_replicas" {
  description = "Number of HA replicas"
  type        = number
  default     = 2
}

variable "server_ha_raft_enabled" {
  description = "Enable Raft storage for HA"
  type        = bool
  default     = false
}

variable "server_ha_raft_set_node_id" {
  description = "Set Raft node ID to pod name"
  type        = bool
  default     = false
}

variable "server_ha_config" {
  description = "HA server config (HCL)"
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
}

# ============================================
# UI Configuration
# ============================================

variable "ui_enabled" {
  description = "Enable web UI"
  type        = bool
  default     = true
}

variable "ui_external_port" {
  description = "External UI port"
  type        = number
  default     = 80
}

# ============================================
# Additional Helm Values
# ============================================

variable "values" {
  description = "Additional Helm values to merge (supports all chart values). These values will override any defaults."
  type        = any
  default     = {}
}
