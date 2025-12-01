variable "namespace" {
  description = "Namespace for Kafka Connect deployment"
  type        = string
  default     = "kafka"
}

variable "kafka_connect_name" {
  description = "Kafka Connect deployment name"
  type        = string
  default     = "kafka-connect"
}

variable "kafka_connect_replicas" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

variable "kafka_bootstrap_servers" {
  description = "Kafka bootstrap servers (list)"
  type        = list(string)
}

variable "schema_registry_url" {
  description = "Schema Registry URL"
  type        = string
}

variable "kafka_connect_resources_config" {
  description = "Resource requests/limits"
  type = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    limits = {
      cpu    = "1"
      memory = "4Gi"
    }
    requests = {
      cpu    = "250m"
      memory = "256Mi"
    }
  }
}

variable "kafka_connect_image" {
  description = "Container image"
  type        = string
  default     = "registry.gitlab.com/daun-gatal/image-repo/kafka-connect:8.0.0"
}

variable "tailscale_expose" {
  description = "Expose service via Tailscale"
  type        = bool
  default     = false
}

variable "connect_group_id" {
  description = "Connect cluster group ID"
  type        = string
  default     = "compose-connect-group"
}

variable "connect_config_storage_topic" {
  description = "Config storage topic name"
  type        = string
  default     = "_connect_configs"
}

variable "connect_config_storage_replication_factor" {
  description = "Config topic replication factor"
  type        = number
  default     = 1
}

variable "connect_offset_storage_topic" {
  description = "Offset storage topic name"
  type        = string
  default     = "_connect_offset"
}

variable "connect_offset_storage_replication_factor" {
  description = "Offset topic replication factor"
  type        = number
  default     = 1
}

variable "connect_status_storage_topic" {
  description = "Status storage topic name"
  type        = string
  default     = "_connect_status"
}

variable "connect_status_storage_replication_factor" {
  description = "Status topic replication factor"
  type        = number
  default     = 1
}