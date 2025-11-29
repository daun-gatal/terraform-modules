variable "namespace" {
  description = "The namespace to deploy Kafka service into"
  type        = string
  default     = "kafka"
}

variable "kafka_schema_registry_name" {
  description = "Name of the schema registry deployment"
  type        = string
  default    = "kafka-schema-registry"
}

variable "kafka_schema_registry_replicas" {
  description = "Number of Kafka Schema Registry replicas"
  type        = number
  default     = 1
}

variable "kafka_bootstrap_servers" {
  description = "Kafka bootstrap servers list"
  type        = list(string)
}

variable "kafka_schema_registry_resources_config" {
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
      memory = "1Gi"
    }
    requests = {
      cpu    = "250m"
      memory = "256Mi"
    }
  }
}

variable "schema_registry_version" {
  description = "Kafka Schema Registry version"
  type        = string
  default     = "8.0.0"
}

variable "tailscale_expose" {
  description = "Whether to expose Kafka via Tailscale"
  type        = bool
  default     = false
}