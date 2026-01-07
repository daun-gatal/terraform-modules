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

variable "image_repository" {
  description = "UI image repository"
  type        = string
  default     = "ghcr.io/caioricciuti/ch-ui"
}

variable "image_tag" {
  description = "UI image tag"
  type        = string
  default     = "latest"
}

variable "clickhouse_urls" {
  description = "URLs of the ClickHouse server (e.g. http://service:8123). Separate multiple URLs with commas."
  type        = string
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
