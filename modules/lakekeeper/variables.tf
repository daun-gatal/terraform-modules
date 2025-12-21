# ============================================
# Core Configuration
# ============================================

variable "namespace" {
  description = "Namespace for Lakekeeper deployment"
  type        = string
  default     = "lakekeeper"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "lakekeeper"
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
  default     = "lakekeeper"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "0.1.0"
}

variable "chart_repository" {
  description = "Helm chart repository"
  type        = string
  default     = "https://lakekeeper.github.io/lakekeeper-charts/"
}

# ============================================
# Catalog Configuration
# ============================================

variable "catalog_config" {
  description = "Configuration options for the catalog (environment variables)"
  type        = map(string)
  default     = {}
}

variable "catalog_replicas" {
  description = "Number of replicas to deploy"
  type        = number
  default     = 1
}

# ============================================
# Database Configuration
# ============================================

variable "database_type" {
  description = "Type of external database (postgres)"
  type        = string
  default     = "postgres"
}

variable "database_host_read" {
  description = "Hostname for read instances of the external database"
  type        = string
  default     = "localhost"
}

variable "database_host_write" {
  description = "Hostname for write instances of the external database"
  type        = string
  default     = "localhost"
}

variable "database_port" {
  description = "Port of the external database"
  type        = number
  default     = 5432
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "catalog"
}

variable "database_user" {
  description = "Database user"
  type        = string
  default     = "catalog"
}

variable "database_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = ""
}



# ============================================
# Service Configuration
# ============================================

variable "tailscale_expose" {
  description = "Expose service via Tailscale"
  type        = bool
  default     = false
}

variable "tailscale_funnel" {
  description = "Expose service via Tailscale Funnel (public ingress)"
  type        = bool
  default     = false
}

# ============================================
# Resources Configuration
# ============================================

variable "resources_config" {
  description = "Resource requests/limits per component"
  type = map(object({
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
  }))
  default = {}
}

# ============================================
# Additional Helm Values
# ============================================

variable "values" {
  description = "Additional Helm values to merge"
  type        = any
  default     = {}
}
