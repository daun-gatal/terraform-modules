variable "namespace" {
  description = "Namespace for ClickHouse UI"
  type        = string
  default     = "clickhouse"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "clickhouse-ui"
}

variable "image_tag" {
  description = "UI image tag"
  type        = string
  default     = "latest"
}

variable "env_vars" {
  description = "Additional environment variables to pass to the container"
  type        = map(string)
  default     = {}
}

variable "tailscale_expose" {
  description = "Expose service via Tailscale"
  type        = bool
  default     = false
}

variable "tailscale_funnel" {
  description = "Expose service via Tailscale Funnel (Ingress)"
  type        = bool
  default     = false
}

variable "resources" {
  description = "Resource limits and requests for UI"
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    requests = {
      cpu    = "10m"
      memory = "32Mi"
    }
    limits = {
      cpu    = "300m"
      memory = "512Mi"
    }
  }
}
