# ============================================
# Core Configuration
# ============================================

variable "namespace" {
  description = "Namespace for Trino deployment"
  type        = string
  default     = "trino"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "trino"
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
  default     = "trino"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "1.40.0"
}

# ============================================
# Image Configuration
# ============================================

variable "image_repository" {
  description = "Container image repository"
  type        = string
  default     = "trinodb/trino"
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "477"
}

# ============================================
# Coordinator Configuration
# ============================================

variable "trino_coordinator_jvm_max_heap_size" {
  description = "Coordinator JVM max heap size"
  type        = string
  default     = "6G"
}

variable "trino_coordinator_query_max_memory" {
  description = "Coordinator max query memory"
  type        = string
  default     = "1GB"
}

variable "coordinator_as_worker" {
  description = "Use coordinator as worker node"
  type        = bool
  default     = false
}

# ============================================
# Worker Configuration
# ============================================

variable "worker_count" {
  description = "Number of worker replicas"
  type        = number
  default     = 1
}



variable "trino_worker_jvm_max_heap_size" {
  description = "Worker JVM max heap size"
  type        = string
  default     = "6G"
}

variable "trino_worker_query_max_memory" {
  description = "Worker max query memory"
  type        = string
  default     = "1GB"
}

# ============================================
# Security Configuration
# ============================================

variable "trino_shared_secret" {
  description = "Shared secret for internal communication"
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
# Catalog Configuration
# ============================================

variable "enabled_catalogs" {
  description = "Catalogs to enable (name + params)"
  type = list(object({
    name   = string
    params = map(string)
  }))
  sensitive = true
  default   = []
}

# ============================================
# Additional Configuration
# ============================================

variable "additional_config_properties" {
  description = "Additional server config properties"
  type        = list(string)
  default     = []
}

# ============================================
# Resources Configuration
# ============================================

variable "trino_resources_config" {
  description = "Resource requests/limits per component. Empty by default - no resources applied to avoid CPU issues on k3s."
  type = object({
    coordinator = optional(object({
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
    worker = optional(object({
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
  })

  default = {}
}

# ============================================
# Additional Helm Values
# ============================================

variable "values" {
  description = "Additional Helm values to merge (supports all chart values). These values will override any defaults."
  type        = any
  default     = {}
}
