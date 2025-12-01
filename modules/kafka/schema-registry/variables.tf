variable "namespace" {
  description = "Namespace for Schema Registry deployment"
  type        = string
  default     = "kafka"
}

variable "kafka_schema_registry_name" {
  description = "Schema Registry deployment name"
  type        = string
  default     = "kafka-schema-registry"
}

variable "kafka_schema_registry_replicas" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

variable "kafka_bootstrap_servers" {
  description = "Kafka bootstrap servers (list)"
  type        = list(string)
}

variable "kafka_schema_registry_resources_config" {
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
      memory = "1Gi"
    }
    requests = {
      cpu    = "250m"
      memory = "256Mi"
    }
  }
}

variable "schema_registry_version" {
  description = "Schema Registry version"
  type        = string
  default     = "8.0.0"
}

variable "tailscale_expose" {
  description = "Expose service via Tailscale"
  type        = bool
  default     = false
}