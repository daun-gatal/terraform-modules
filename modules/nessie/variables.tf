# ============================================
# Core Configuration
# ============================================

variable "namespace" {
  description = "Namespace for Nessie deployment"
  type        = string
  default     = "nessie"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "nessie"
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
  default     = "nessie"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "0.104.10"
}

# ============================================
# JDBC Configuration
# ============================================

variable "nessie_jdbc_username" {
  description = "JDBC username"
  type        = string
  sensitive   = true
}

variable "nessie_jdbc_password" {
  description = "JDBC password"
  type        = string
  sensitive   = true
}

variable "nessie_jdbc_url" {
  description = "JDBC URL (hostname)"
  type        = string
}

variable "nessie_jdbc_port" {
  description = "JDBC port"
  type        = string
}

variable "nessie_database_name" {
  description = "Database name"
  type        = string
}

# ============================================
# Warehouse Configuration
# ============================================

variable "nessie_default_warehouse" {
  description = "Default warehouse path"
  type        = string
  default     = "warehouse"
}

# ============================================
# S3/MinIO Configuration
# ============================================

variable "nessie_s3_bucket" {
  description = "S3/MinIO bucket name"
  type        = string
}

variable "nessie_s3_endpoint" {
  description = "S3/MinIO endpoint (http://host:port)"
  type        = string
}

variable "nessie_s3_region" {
  description = "S3/MinIO region"
  type        = string
  default     = "us-east-1"
}

variable "nessie_s3_access_key_name" {
  description = "S3/MinIO access key"
  type        = string
  sensitive   = true
}

variable "nessie_s3_access_key_secret" {
  description = "S3/MinIO secret key"
  type        = string
  sensitive   = true
}

# ============================================
# Service Configuration
# ============================================

variable "tailscale_expose" {
  description = "Expose service via Tailscale"
  type        = bool
  default     = false
}

# ============================================
# Resources Configuration
# ============================================

variable "nessie_resources_config" {
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

# ============================================
# Additional Helm Values
# ============================================

variable "values" {
  description = "Additional Helm values to merge (supports all chart values). These values will override any defaults."
  type        = any
  default     = {}
}
