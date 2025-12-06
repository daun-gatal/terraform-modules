# ============================================
# Core Configuration
# ============================================

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "rustfs"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "rustfs"
}

variable "chart_version" {
  description = "RustFS Helm chart version"
  type        = string
  default     = "0.1.1"
}

variable "fullname_override" {
  description = "String to fully override rustfs.fullname"
  type        = string
  default     = "rustfs-release"
}

# ============================================
# Image Configuration
# ============================================

variable "image_registry" {
  description = "RustFS image registry"
  type        = string
  default     = "docker.io"
}

variable "image_repository" {
  description = "RustFS image repository"
  type        = string
  default     = "rustfs/rustfs"
}

variable "image_tag" {
  description = "RustFS image tag"
  type        = string
  default     = "latest"
}

variable "image_pull_policy" {
  description = "RustFS image pull policy"
  type        = string
  default     = "Always"
}

# ============================================
# Authentication Configuration
# ============================================

variable "auth_access_key" {
  description = "RustFS access key"
  type        = string
  default     = "rustfsadmin"
  sensitive   = true
}

variable "auth_secret_key" {
  description = "RustFS secret key. If not set, a random password will be generated"
  type        = string
  default     = "rustfssecret"
  sensitive   = true
}

variable "auth_existing_secret" {
  description = "Name of existing secret containing RustFS credentials"
  type        = string
  default     = ""
}

# ============================================
# Deployment Configuration
# ============================================

variable "replica_count" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

variable "deployment_type" {
  description = "Type of deployment (deployment or statefulset)"
  type        = string
  default     = "deployment"

  validation {
    condition     = contains(["deployment", "statefulset"], var.deployment_type)
    error_message = "Deployment type must be either 'deployment' or 'statefulset'"
  }
}

# ============================================
# Service Configuration
# ============================================

variable "service_type" {
  description = "RustFS service type"
  type        = string
  default     = "ClusterIP"
}

variable "service_port" {
  description = "RustFS API service port"
  type        = number
  default     = 9000
}

variable "service_console_port" {
  description = "RustFS console service port"
  type        = number
  default     = 9001
}

variable "service_annotations" {
  description = "Service annotations"
  type        = map(string)
  default     = {}
}

# ============================================
# Resources Configuration
# ============================================

variable "resources" {
  description = "Container resource requests and limits"
  type = object({
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }), {})
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }), {})
  })
  default = {}
}

# ============================================
# Additional Helm Values
# ============================================

variable "values" {
  description = "Additional Helm values to merge (supports all chart values including config, ingress, persistence, probes, etc.)"
  type        = any
  default     = {}
}
