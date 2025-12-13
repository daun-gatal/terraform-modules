variable "namespace" {
  description = "Namespace for Kafka UI deployment"
  type        = string
  default     = "kafka"
}

variable "kafka_ui_name" {
  description = "Kafka UI deployment name"
  type        = string
  default     = "kafka-ui"
}

variable "kafka_ui_version" {
  description = "Kafka UI version"
  type        = string
  default     = "e3ba25f"
}

variable "kafka_ui_secret_name" {
  description = "Secret name for environment variables"
  type        = string
  default     = "kafka-config-secret"
}

variable "kafka_ui_resources_config" {
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

variable "tailscale_expose" {
  description = "Expose service via Tailscale"
  type        = bool
  default     = false
}

variable "tailscale_funnel" {
  description = "Enable Tailscale Funnel for the Superset service"
  type        = bool
  default     = false
}