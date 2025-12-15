variable "namespace" {
  description = "Namespace for ksqlDB deployment"
  type        = string
  default     = "kafka"
}

variable "kafka_ksqldb_name" {
  description = "ksqlDB StatefulSet name"
  type        = string
  default     = "kafka-ksqldb-server"
}

variable "ksqldb_version" {
  description = "ksqlDB version"
  type        = string
  default     = "8.0.0"
}

variable "kafka_bootstrap_servers" {
  description = "Kafka bootstrap servers (list)"
  type        = list(string)
}

variable "kafka_schema_registry_url" {
  description = "Schema Registry URL"
  type        = string
}

variable "kafka_ksqldb_resources_config" {
  description = "Resource requests/limits. Empty by default - no resources applied to avoid CPU issues on k3s."
  type = object({
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
  })
  default = null
}

variable "kafka_ksqldb_storage_size" {
  description = "Persistent volume size"
  type        = string
  default     = "5Gi"
}

variable "ksqldb_storage_class_name" {
  description = "Storage class for persistent volume"
  type        = string
  default     = "standard"
}

variable "tailscale_expose" {
  description = "Expose service via Tailscale"
  type        = bool
  default     = false
}