# ============================================
# Core Configuration
# ============================================

variable "namespace" {
  description = "Kubernetes namespace for Airbyte deployment"
  type        = string
  default     = "airbyte"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "airbyte"
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
  default     = "airbyte"
}

variable "chart_version" {
  description = "Helm chart version (v2 chart - versions 2.x.x)"
  type        = string
  default     = "2.0.8"
}

variable "chart_repository" {
  description = "Helm chart repository URL (equivalent to: helm repo add airbyte-v2 <url>)"
  type        = string
  default     = "https://airbytehq.github.io/charts"
}

# ============================================
# Component Configuration
# ============================================

variable "postgresql_enabled" {
  description = "Enable internal PostgreSQL"
  type        = bool
  default     = true
}

variable "minio_enabled" {
  description = "Enable internal MinIO"
  type        = bool
  default     = true
}

# ============================================
# Additional Helm Values Override
# ============================================

variable "values" {
  description = "Additional Helm values to merge. These will override any module defaults."
  type        = any
  default     = {}
}
