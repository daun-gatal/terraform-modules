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

variable "worker_count" {
  description = "Number of worker replicas"
  type        = number
  default     = 1
}

variable "worker_query_max_memory" {
  description = "Max query memory per worker"
  type        = string
  default     = "4GB"
}

variable "tailscale_expose" {
  description = "Expose service via Tailscale"
  type        = bool
  default     = false
}

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

variable "trino_shared_secret" {
  description = "Shared secret for internal communication"
  type        = string
  sensitive   = true
}

variable "coordinator_as_worker" {
  description = "Use coordinator as worker node"
  type        = bool
  default     = false
}

# Catalog Configuration
variable "enabled_catalogs" {
  description = "Catalogs to enable (name + params)"
  type = list(object({
    name   = string
    params = map(string)
  }))
  sensitive = true
  default   = []
}

# Additional Configuration
variable "additional_config_properties" {
  description = "Additional server config properties"
  type        = list(string)
  default     = []
}

variable "trino_resources_config" {
  description = "Resource requests/limits per component"
  type = map(object({
    requests = optional(object({
      cpu = optional(string)
      ram = optional(string)
    }))
    limits = optional(object({
      cpu = optional(string)
      ram = optional(string)
    }))
  }))

  default = {
    coordinator = {
      requests = {
        cpu = "200m"
        ram = "512Mi"
      }
      limits = {
        cpu = "2000m"
        ram = "6144Mi"
      }
    }

    worker = {
      requests = {
        cpu = "200m"
        ram = "512Mi"
      }
      limits = {
        cpu = "2000m"
        ram = "6144Mi"
      }
    }
  }
}