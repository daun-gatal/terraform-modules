variable "namespace" {
  description = "Namespace for ClickHouse Keeper"
  type        = string
  default     = "clickhouse"
}

variable "cluster_name" {
  description = "ClickHouse Keeper cluster name"
  type        = string
  default     = "clickhouse-keepers"
}

variable "replicas" {
  description = "Number of Keeper replicas"
  type        = number
  default     = 3
}

variable "image_repository" {
  description = "Keeper image repository"
  type        = string
  default     = "clickhouse/clickhouse-keeper"
}

variable "image_tag" {
  description = "Keeper image tag"
  type        = string
  default     = "25.11-alpine"
}

variable "storage_class" {
  description = "Storage Class for Keeper PVC"
  type        = string
  default     = "standard"
}

variable "pvc_size" {
  description = "Size of Keeper PVC"
  type        = string
  default     = "10Gi"
}

variable "resources" {
  description = "Resource limits and requests for Keeper"
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    requests = {
      cpu    = "10m"
      memory = "64Mi"
    }
    limits = {
      cpu    = "200m"
      memory = "512Mi"
    }
  }
}
