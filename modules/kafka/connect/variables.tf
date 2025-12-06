
variable "namespace" {
  description = "Namespace for Kafka Connect deployment"
  type        = string
  default     = "kafka"
}

variable "kafka_connect_instances" {
  description = "Map of Kafka Connect deployments (auto-generated default from existing variables)"
  sensitive = true

  type = map(object({
    replicas = number
    image    = string
    kafka_connect_name = string

    kafka_bootstrap_servers = list(string)
    schema_registry_url     = string
    tailscale_expose        = bool

    resources = object({
      limits = object({
        cpu    = string
        memory = string
      })
      requests = object({
        cpu    = string
        memory = string
      })
    })

    connect_config_storage_replication_factor = number
    connect_offset_storage_replication_factor = number
    connect_status_storage_replication_factor = number
  }))
}
