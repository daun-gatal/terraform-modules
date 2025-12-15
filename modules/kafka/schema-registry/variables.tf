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