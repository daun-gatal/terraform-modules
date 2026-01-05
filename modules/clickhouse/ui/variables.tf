variable "namespace" {
  description = "Namespace for ClickHouse UI"
  type        = string
  default     = "clickhouse"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "ch-ui"
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

variable "clickhouse_url" {
  description = "URL of the ClickHouse server (e.g. http://service:8123)"
  type        = string
}

variable "clickhouse_user" {
  description = "ClickHouse username"
  type        = string
  default     = "admin"
}

variable "clickhouse_password_secret" {
  description = "Name of the secret containing the password"
  type        = string
}

variable "clickhouse_password_key" {
  description = "Key in the secret containing the password"
  type        = string
  default     = "admin-password"
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
