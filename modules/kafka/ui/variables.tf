variable "namespace" {
  description = "The namespace to deploy Kafka service into"
  type        = string
  default     = "kafka"
}

variable "kafka_ui_name" {
  description = "Name for the Kafka UI deployment and service"
  type        = string
  default     = "kafka-ui"
}

variable "kafka_ui_version" {
  description = "Version of Kafka UI to deploy"
  type        = string
  default     = "e3ba25f"
}

variable "kafka_ui_secret_name" {
  description = "Name of the Kubernetes secret containing Kafka UI environment variables"
  type        = string
  default     = "kafka-config-secret"
}

variable "kafka_ui_resources_config" {
  description = "Resource configuration for Kafka UI pods in YAML format"
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

variable "tailscale_expose" {
  description = "Whether to expose Kafka via Tailscale"
  type        = bool
  default     = false
}