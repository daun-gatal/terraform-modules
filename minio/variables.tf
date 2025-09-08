# MinIO Development-Focused Configuration Variables
# Simplified for development use with sensible defaults

# Basic Configuration
variable "namespace" {
  description = "The namespace to deploy MinIO into"
  type        = string
  default     = "minio"
}

variable "tenant_name" {
  description = "The MinIO tenant name"
  type        = string
  default     = "dev-minio"
}

# Authentication
variable "minio_root_user" {
  description = "MinIO root username"
  type        = string
  default     = "minio"
  sensitive   = true
}

variable "minio_root_password" {
  description = "MinIO root password (minimum 8 characters)"
  type        = string
  default     = "minio123"
  sensitive   = true

  validation {
    condition     = length(var.minio_root_password) >= 8
    error_message = "MinIO root password must be at least 8 characters long."
  }
}

# Storage Configuration (simplified)
variable "storage_size" {
  description = "Storage size per volume"
  type        = string
  default     = "5Gi"
}

variable "storage_class_name" {
  description = "Storage class name for persistent volumes (empty = default)"
  type        = string
  default     = "standard"
}

variable "buckets" {
  description = "List of buckets to create automatically with optional retention settings"
  type = list(object({
    name                    = string
    service                 = optional(string, null)  # Service name for mapping (e.g., "airflow", "spark")
    region                  = optional(string, "us-east-1")
    expire_days             = optional(number, null)  # Delete objects after N days
    noncurrent_expire_days  = optional(number, null)  # Delete old versions after N days
    }))
  default = [
    {
      name = "dev-data"
    }
  ]
}

variable "enable_tls" {
  description = "Enable TLS certificates (disable for simple dev setup)"
  type        = bool
  default     = false
}

# Tailscale (for easy development access)
variable "tailscale_expose" {
  description = "Expose MinIO API via Tailscale"
  type        = bool
  default     = false
}

# Advanced Options (mostly disabled for development)
variable "enable_distributed" {
  description = "Enable distributed mode (4+ servers) vs single server"
  type        = bool
  default     = false
}

