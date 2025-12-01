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
  default     = "gravitino-iceberg-rest"
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
# Catalog Configuration
# ============================================

variable "catalog_backend" {
  description = "Iceberg catalog backend (memory, hive, jdbc)"
  type        = string
  default     = "memory"
}

variable "warehouse" {
  description = "Iceberg warehouse location (e.g., s3://bucket/path, /tmp/)"
  type        = string
  default     = "/tmp/"
}

variable "jdbc_config" {
  description = "JDBC configuration for catalog backend"
  type = object({
    url        = string
    user       = string
    password   = string
    driver     = optional(string, "com.mysql.cj.jdbc.Driver")
    initialize = optional(bool, true)
  })
  default   = null
  sensitive = true
}

# ============================================
# Storage Configuration
# ============================================

variable "s3_config" {
  description = "S3 storage configuration"
  type = object({
    access_key_id     = string
    secret_access_key = string
    endpoint          = optional(string)
    region            = optional(string, "us-east-1")
    path_style_access = optional(bool, true)
  })
  default   = null
  sensitive = true
}

variable "io_impl" {
  description = "Iceberg FileIO implementation (e.g., org.apache.iceberg.aws.s3.S3FileIO)"
  type        = string
  default     = null
}

# ============================================
# Resources Configuration
# ============================================

variable "resources" {
  description = "Container resource requests and limits"
  type = object({
    requests = optional(object({
      cpu    = optional(string, "1")
      memory = optional(string, "2Gi")
    }), {})
    limits = optional(object({
      cpu    = optional(string, "2")
      memory = optional(string, "4Gi")
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
