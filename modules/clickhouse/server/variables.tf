variable "namespace" {
  description = "Namespace for ClickHouse Server"
  type        = string
  default     = "clickhouse"
}

variable "cluster_name" {
  description = "ClickHouse Cluster Name (CHI name)"
  type        = string
  default     = "clickhouse"
}

variable "keeper_service_name" {
  description = "Headless service name of the Keeper cluster"
  type        = string
}

variable "keeper_replicas" {
  description = "Number of Keeper replicas (to generate config)"
  type        = number
  default     = 3
}

variable "shards_count" {
  description = "Number of shards"
  type        = number
  default     = 2
}

variable "replicas_count" {
  description = "Number of replicas per shard"
  type        = number
  default     = 2
}

variable "admin_password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}

variable "storage_class" {
  description = "Storage Class for Data PVC"
  type        = string
  default     = "standard"
}

variable "pvc_size" {
  description = "Size of Data PVC"
  type        = string
  default     = "25Gi"
}

variable "image_repository" {
  description = "ClickHouse Server image repository"
  type        = string
  default     = "clickhouse/clickhouse-server"
}

variable "image_tag" {
  description = "ClickHouse Server image tag"
  type        = string
  default     = "25.11"
}

variable "resources" {
  description = "Resource limits and requests for Server"
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
      cpu    = "100m"
      memory = "256Mi"
    }
    limits = {
      cpu    = "1"
      memory = "4Gi"
    }
  }
}
