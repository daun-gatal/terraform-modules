variable "namespace" {
  description = "The namespace to deploy Trino service into"
  type        = string
  default     = "trino"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "trino"
}

variable "chart_name" {
  description = "The Helm chart name for Trino"
  type        = string
  default     = "trino"
}

variable "chart_version" {
  description = "The Helm chart version for Trino"
  type        = string
  default     = "1.40.0"
}

variable "image_repository" {
  description = "The image repository for Trino"
  type        = string
  default     = "trinodb/trino"
}

variable "image_tag" {
  description = "The image tag for Trino"
  type        = string
  default     = "477"
}

variable "worker_count" {
  description = "The number of Trino worker replicas"
  type        = number
  default     = 1
  
}

variable "worker_query_max_memory" {
  description = "The maximum memory for Trino worker queries"
  type        = string
  default     = "4GB"
}

variable "tailscale_expose" {
  description = "Whether to expose Trino via Tailscale"
  type        = bool
  default     = false
  
}

variable "trino_coordinator_jvm_max_heap_size" {
  description = "The maximum heap size for the Trino coordinator JVM"
  type        = string
  default     = "6G"
}

variable "trino_coordinator_query_max_memory" {
  description = "The maximum memory for Trino coordinator queries"
  type        = string
  default     = "1GB"
}

variable "trino_worker_jvm_max_heap_size" {
  description = "The maximum heap size for the Trino worker JVM"
  type        = string
  default     = "6G"
}

variable "trino_worker_query_max_memory" {
  description = "The maximum memory for Trino worker queries"
  type        = string
  default     = "1GB"
}

variable "trino_shared_secret" {
  description = "Shared secret for internal Trino communication"
  type        = string
  sensitive   = true
}

variable "coordinator_as_worker" {
  description = "Whether the coordinator should also act as a worker"
  type        = bool
  default     = false
}

# Catalog Variables
variable "enabled_catalogs" {
  description = "List of catalogs to enable"
  sensitive = true
  type = list(object({
    name      = string       # catalog name in Trino
    params    = map(string)  # raw key=value pairs
  }))

  default = []
}

# Additional Configuration Properties
variable "additional_config_properties" {
  description = "List of additional configuration properties for Trino server (e.g., ['retry-policy=TASK', 'query.max-execution-time=1h'])"
  type        = list(string)
  default     = []
}

variable "trino_resources_config" {
  description = "Resource configuration for Trino pods in YAML format"
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

variable "trino_access_control_entries" {
  description = "List of access control entries for Trino with full fields for catalogs, schemas, and tables"
  type = list(object({
    user     = optional(string)
    role     = optional(string)
    group    = optional(string)

    catalogs = optional(list(object({
      catalog = optional(string)
      allow   = string  # required
    })), [])

    schemas = optional(list(object({
      catalog = optional(string)
      schema  = optional(string)
      owner   = bool   # required
    })), [])

    tables = optional(list(object({
      catalog = optional(string)
      schema  = optional(string)
      table   = optional(string)
      privileges = list(string)  # required
    })), [])
  }))
  default = [
    {
      user  = "admin"
      catalogs = [
        { allow = "all" }
      ]
      schemas = [
        { owner = true }
      ]
      tables = [
        { privileges = ["SELECT"] }
      ]
    }
  ]
}
