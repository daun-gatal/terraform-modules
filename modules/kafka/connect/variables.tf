
variable "namespace" {
  description = "Namespace for Kafka Connect deployment"
  type        = string
  default     = "kafka"
}

variable "kafka_connect_instances" {
  description = "Map of Kafka Connect deployments. Resources are optional - empty by default to avoid CPU issues on k3s."

  type = map(object({
    replicas           = number
    image              = string
    kafka_connect_name = string

    kafka_bootstrap_servers = list(string)
    schema_registry_url     = string
    tailscale_expose        = bool

    resources = optional(object({
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))

    connect_config_storage_replication_factor = number
    connect_offset_storage_replication_factor = number
    connect_status_storage_replication_factor = number
  }))
}
