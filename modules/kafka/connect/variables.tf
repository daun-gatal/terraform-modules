variable "namespace" {
  description = "The namespace to deploy Kafka service into"
  type        = string
  default     = "kafka"
}

variable "kafka_connect_name" {
  description = "Name of the schema registry deployment"
  type        = string
  default    = "kafka-connect"
}

variable "kafka_connect_replicas" {
  description = "Number of Kafka Schema Registry replicas"
  type        = number
  default     = 1
}

variable "kafka_bootstrap_servers" {
  description = "Kafka bootstrap servers list"
  type        = list(string)
}

variable "schema_registry_url" {
  description = "Schema Registry URL"
  type        = string
}

variable "kafka_connect_resources_config" {
  description = "Resource configuration for Kafka Schema Registry pods in YAML format"
  type        = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    }) 
  })
  default     = {
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
  description = "Kafka Connect Docker image"
  type        = string
  default     = "registry.gitlab.com/daun-gatal/image-repo/kafka-connect:8.0.0"
}

variable "tailscale_expose" {
  description = "Whether to expose Kafka via Tailscale"
  type        = bool
  default     = false
}