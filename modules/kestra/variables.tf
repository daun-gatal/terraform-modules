# ============================================
# Core Configuration
# ============================================

variable "namespace" {
  description = "Namespace for Kestra deployment"
  type        = string
  default     = "kestra"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "kestra"
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
  default     = "kestra"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "1.0.22"
}

variable "chart_repository" {
  description = "Helm chart repository URL"
  type        = string
  default     = "https://helm.kestra.io"
}

# ============================================
# Image Configuration
# ============================================

variable "image_repository" {
  description = "Container image repository"
  type        = string
  default     = "kestra/kestra"
}

variable "image_tag" {
  description = "Container image tag (defaults to chart appVersion if empty)"
  type        = string
  default     = ""
}

variable "image_pull_policy" {
  description = "Image pull policy (Always, IfNotPresent, Never)"
  type        = string
  default     = "IfNotPresent"

  validation {
    condition     = contains(["Always", "IfNotPresent", "Never"], var.image_pull_policy)
    error_message = "Must be 'Always', 'IfNotPresent', or 'Never'"
  }
}

variable "image_pull_secrets" {
  description = "List of image pull secrets"
  type        = list(map(string))
  default     = []
}

# ============================================
# Deployment Mode Configuration
# ============================================

variable "deployment_mode" {
  description = "Deployment mode: 'standalone' or 'distributed'"
  type        = string
  default     = "standalone"

  validation {
    condition     = contains(["standalone", "distributed"], var.deployment_mode)
    error_message = "Must be 'standalone' or 'distributed'"
  }
}

variable "replicas" {
  description = "Number of pod replicas (for standalone mode)"
  type        = number
  default     = 1
}

variable "worker_threads" {
  description = "Number of worker threads (0 for auto-configure based on CPU)"
  type        = number
  default     = 0
}

# ============================================
# Kestra Application Configuration
# ============================================

variable "application_config" {
  description = "Kestra application configuration (datasources, storage, queue, etc.)"
  type        = any
  default     = {}
}

variable "configuration_secrets" {
  description = "List of secrets to mount as configuration files"
  type = list(object({
    name = string
    key  = string
  }))
  default = []
}

variable "configuration_configmaps" {
  description = "List of configmaps to mount as configuration files"
  type = list(object({
    name = string
    key  = string
  }))
  default = []
}

# ============================================
# Docker-in-Docker (dind) Configuration
# ============================================

variable "dind_enabled" {
  description = "Enable Docker-in-Docker sidecar"
  type        = bool
  default     = true
}

variable "dind_mode" {
  description = "Dind mode: 'rootless' or 'insecure'"
  type        = string
  default     = "rootless"

  validation {
    condition     = contains(["rootless", "insecure"], var.dind_mode)
    error_message = "Must be 'rootless' or 'insecure'"
  }
}

variable "dind_resources" {
  description = "Resource requests and limits for dind sidecar"
  type = object({
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
  })
  default = {}
}

# ============================================
# Service Configuration
# ============================================

variable "service_type" {
  description = "Kubernetes Service type"
  type        = string
  default     = "ClusterIP"

  validation {
    condition     = contains(["ClusterIP", "NodePort", "LoadBalancer"], var.service_type)
    error_message = "Must be 'ClusterIP', 'NodePort', or 'LoadBalancer'"
  }
}

variable "service_annotations" {
  description = "Annotations to apply to the Service"
  type        = map(string)
  default     = {}
}

variable "tailscale_expose" {
  description = "Expose service via Tailscale"
  type        = bool
  default     = false
}

# ============================================
# Resources Configuration
# ============================================

variable "resources" {
  description = "Resource requests and limits for containers"
  type = object({
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
  })
  default = {}
}

# ============================================
# Autoscaling Configuration
# ============================================

variable "autoscaler_enabled" {
  description = "Enable horizontal pod autoscaling"
  type        = bool
  default     = false
}

variable "autoscaler_min_replicas" {
  description = "Minimum replicas for autoscaling"
  type        = number
  default     = 1
}

variable "autoscaler_max_replicas" {
  description = "Maximum replicas for autoscaling"
  type        = number
  default     = 3
}

variable "autoscaler_metrics" {
  description = "Metrics configuration for autoscaling"
  type        = any
  default     = []
}

# ============================================
# Additional Helm Values
# ============================================

variable "values" {
  description = "Additional Helm values to merge (supports all chart values). These values will override any defaults."
  type        = any
  default     = {}
}

