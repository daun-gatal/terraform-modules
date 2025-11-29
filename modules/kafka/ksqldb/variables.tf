variable "namespace" {
  description = "The namespace to deploy Kafka service into"
  type        = string
  default     = "kafka"
}

variable "kafka_ksqldb_name" {
  description = "KSQLDB stateful set name"
  type        = string
  default     = "kafka-ksqldb-server"
}

variable "ksqldb_version" {
  description = "KSQLDB version"
  type        = string
  default     = "8.0.0"
}

variable "kafka_bootstrap_servers" {
  description = "Kafka bootstrap servers list"
  type        = list(string)
}

variable "kafka_schema_registry_url" {
  description = "Kafka Schema Registry URL"
  type        = string
}

variable "kafka_ksqldb_resources_config" {
  description = "Resource configuration for Kafka KSQLDB pods in YAML format"
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

variable "kafka_ksqldb_storage_size" {
  description = "Persistent volume size for KSQLDB"
  type        = string
  default     = "5Gi"
}

variable "ksqldb_storage_class_name" {
  description = "Persistent volume storage class name for KSQLDB"
  type        = string
  default     = "standard"
}

variable "tailscale_expose" {
  description = "Whether to expose Kafka via Tailscale"
  type        = bool
  default     = false
}