# Basic Configuration
variable "namespace" {
  description = "Namespace for MinIO deployment"
  type        = string
  default     = "minio"
}

variable "tenant_name" {
  description = "MinIO tenant name"
  type        = string
  default     = "dev-minio"
}

# Authentication
variable "minio_root_user" {
  description = "Root username"
  type        = string
  default     = "minio"
  sensitive   = true
}

variable "minio_root_password" {
  description = "Root password (min 8 chars)"
  type        = string
  default     = "minio123"
  sensitive   = true

  validation {
    condition     = length(var.minio_root_password) >= 8
    error_message = "Password must be at least 8 characters"
  }
}

# Storage Configuration
variable "storage_size" {
  description = "Storage size per volume"
  type        = string
  default     = "5Gi"
}

variable "storage_class_name" {
  description = "Storage class for persistent volumes"
  type        = string
  default     = "standard"
}

variable "buckets" {
  description = "Buckets to create with retention settings"
  type = list(object({
    name                   = string
    region                 = optional(string, "us-east-1")
    expire_days            = optional(number, null)
    noncurrent_expire_days = optional(number, null)
  }))
  default = [
    {
      name                   = "default"
      expire_days            = 7
      noncurrent_expire_days = 10
    }
  ]
}

variable "enable_tls" {
  description = "Enable TLS certificates"
  type        = bool
  default     = false
}

variable "image_repository" {
  description = "Container image repository"
  type        = string
  default     = "quay.io/minio/minio"
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "RELEASE.2025-04-08T15-41-24Z"
}

variable "tailscale_expose" {
  description = "Expose API via Tailscale"
  type        = bool
  default     = false
}

variable "enable_distributed" {
  description = "Enable distributed mode (4+ servers)"
  type        = bool
  default     = false
}

variable "minio_resources_config" {
  description = "Resource requests/limits. Empty by default - no resources applied to avoid CPU issues on k3s."
  type = object({
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
  })
  default = null
}
