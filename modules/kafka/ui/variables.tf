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