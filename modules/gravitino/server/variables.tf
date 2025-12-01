# ============================================
# Core Configuration
# ============================================

variable "gravitino_version" {
  description = "Gravitino version to download (git tag, e.g., v0.7.0)"
  type        = string
  default     = "v1.0.1"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "gravitino"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "gravitino"
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "1.0.1"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

# ============================================
# Database Configuration
# ============================================

variable "mysql_enabled" {
  description = "Enable built-in MySQL deployment"
  type        = bool
  default     = false
}

variable "postgresql_enabled" {
  description = "Enable built-in PostgreSQL deployment"
  type        = bool
  default     = false
}

variable "entity_jdbc_config" {
  description = "External JDBC configuration for entity store"
  type = object({
    url      = string
    driver   = string
    user     = string
    password = string
  })
  default   = null
  sensitive = true
}

# ============================================
# Resources Configuration
# ============================================

variable "resources" {
  description = "Container resource requests and limits"
  type = object({
    requests = optional(object({
      cpu    = optional(string, "500m")
      memory = optional(string, "1Gi")
    }), {})
    limits = optional(object({
      cpu    = optional(string, "2")
      memory = optional(string, "3Gi")
    }), {})
  })
  default = {}
}

# ============================================
# Service Configuration
# ============================================

variable "service_annotations" {
  description = "Service annotations (e.g., for Tailscale)"
  type        = map(string)
  default     = {}
}

variable "service_type" {
  description = "Service type (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "ClusterIP"
}

# ============================================
# Additional Helm Values
# ============================================

variable "values" {
  description = "Additional Helm values to merge (supports all chart values)"
  type        = any
  default     = {}
}
