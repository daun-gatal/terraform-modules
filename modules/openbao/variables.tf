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

variable "image_tag" {
  description = "OpenBao image tag"
  type        = string
  default     = ""
}

# ============================================
# Tailscale Configuration
# ============================================

variable "tailscale_server_expose" {
  description = "Expose server service via Tailscale"
  type        = string
  default     = "false"
}

variable "tailscale_ui_expose" {
  description = "Expose UI service via Tailscale"
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
# Unseal Key Configuration
# ============================================

variable "generate_unseal_key" {
  description = "Whether to generate unseal key automatically or use provided key"
  type        = bool
  default     = true
}

variable "unseal_current_key" {
  description = "Current unseal key (32 bytes, base64 encoded). Required if generate_unseal_key is false"
  type        = string
  default     = ""
  sensitive   = true
}

variable "unseal_current_key_id" {
  description = "Identifier for the current unseal key (e.g., date-based: 2024-12-17)"
  type        = string
  default     = "initial-key"
}

variable "unseal_previous_key" {
  description = "Previous unseal key for rotation (32 bytes, base64 encoded). Optional"
  type        = string
  default     = ""
  sensitive   = true
}

variable "unseal_previous_key_id" {
  description = "Identifier for the previous unseal key. Required if unseal_previous_key is set"
  type        = string
  default     = ""
}

# ============================================
# Storage Backend Configuration
# ============================================

variable "storage_type" {
  description = "Storage backend type: postgresql, raft, file"
  type        = string
  default     = "raft"

  validation {
    condition     = contains(["postgresql", "raft", "file"], var.storage_type)
    error_message = "storage_type must be one of: postgresql, raft, file"
  }
}

# -------------------------------
# PostgreSQL Storage Configuration
# -------------------------------
variable "storage_postgresql" {
  description = "PostgreSQL storage backend configuration. See: https://openbao.org/docs/configuration/storage/postgresql/"
  type = object({
    connection_url       = string
    table                = optional(string, "openbao_kv_store")
    max_idle_connections = optional(number)
    max_parallel         = optional(number, 128)
    ha_enabled           = optional(bool, false)
    ha_table             = optional(string, "openbao_ha_locks")
    skip_create_table    = optional(bool, false)
    max_connect_retries  = optional(number, 1)
  })
  default   = null
  sensitive = true
}

# -------------------------------
# Raft Storage Configuration
# -------------------------------
variable "storage_raft" {
  description = "Raft (integrated) storage backend configuration. See: https://openbao.org/docs/configuration/storage/raft/"
  type = object({
    path                         = optional(string, "/openbao/data")
    node_id                      = optional(string)
    performance_multiplier       = optional(number, 0)
    trailing_logs                = optional(number, 10000)
    snapshot_threshold           = optional(number, 8192)
    snapshot_interval            = optional(string, "120s")
    max_entry_size               = optional(number, 1048576)
    max_transaction_size         = optional(number, 8388608)
    autopilot_reconcile_interval = optional(string, "10s")
    autopilot_update_interval    = optional(string, "2s")
    retry_join = optional(list(object({
      leader_api_addr         = optional(string)
      auto_join               = optional(string)
      auto_join_scheme        = optional(string, "https")
      auto_join_port          = optional(number, 8200)
      leader_tls_servername   = optional(string)
      leader_ca_cert_file     = optional(string)
      leader_client_cert_file = optional(string)
      leader_client_key_file  = optional(string)
    })), [])
  })
  default = {}
}

# -------------------------------
# File Storage Configuration
# -------------------------------
variable "storage_file" {
  description = "File storage backend configuration (development only)"
  type = object({
    path = optional(string, "/openbao/data")
  })
  default = {}
}

# ============================================
# Server PVC Storage Configuration
# ============================================

variable "server_data_storage" {
  description = "Server data storage (PVC) configuration"
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
  description = "Server audit storage (PVC) configuration"
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
  description = "Standalone server config (HCL) - listener configuration only. Storage is managed separately."
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

  validation {
    condition     = var.server_ha_replicas >= 1 && var.server_ha_replicas <= 10
    error_message = "HA replicas must be between 1 and 10."
  }
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
  description = "HA server config (HCL) - listener configuration only. Storage is managed separately."
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
# Plugin Configuration
# ============================================

variable "plugin_directory" {
  description = "Directory from which plugins are loaded. See: https://openbao.org/docs/configuration/"
  type        = string
  default     = "/openbao/plugins"
}

variable "plugin_auto_download" {
  description = "Enable automatic plugin downloading from OCI images. See: https://openbao.org/docs/configuration/plugin/"
  type        = bool
  default     = true
}

variable "plugin_auto_register" {
  description = "Enable automatic plugin registration. See: https://openbao.org/docs/configuration/plugin/"
  type        = bool
  default     = true
}

variable "plugin_download_behavior" {
  description = "Plugin download behavior when download fails: fail, warn, or ignore"
  type        = string
  default     = "warn"

  validation {
    condition     = contains(["fail", "warn", "ignore"], var.plugin_download_behavior)
    error_message = "plugin_download_behavior must be one of: fail, warn, ignore"
  }
}

variable "additional_plugins" {
  description = "Additional plugins to merge with default plugins. See: https://openbao.org/docs/configuration/plugin/"
  type = list(object({
    name        = string               # Plugin name (e.g., "aws", "kubernetes")
    image       = string               # OCI image reference
    version     = string               # Plugin version
    binary_name = string               # Binary name in the image
    sha256sum   = optional(string, "") # SHA256 checksum (optional but recommended)
    type        = string
  }))
  default = []
}

variable "disable_default_plugins" {
  description = "Set to true to disable all default plugins"
  type        = bool
  default     = false
}

# ============================================
# Additional Helm Values
# ============================================

variable "values" {
  description = "Additional Helm values to merge (supports all chart values). These values will override any defaults."
  type        = any
  default     = {}
}
