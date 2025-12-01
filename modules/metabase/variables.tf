variable "namespace" {
  description = "Namespace for Metabase deployment"
  type        = string
  default     = "metabase"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "metabase"
}

variable "metabase_db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "metabase_db_user" {
  description = "Database username"
  type        = string
  default     = "postgres"
  sensitive   = true
}

variable "metabase_db_name" {
  description = "Database name"
  type        = string
  default     = "postgres"
}

variable "metabase_db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "metabase_db_host" {
  description = "Database host"
  type        = string
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "v0.56.x"
}

variable "image" {
  description = "Container image"
  type        = string
  default     = "metabase/metabase"
}

variable "tailscale_expose" {
  description = "Expose service via Tailscale"
  type        = bool
  default     = false
}

variable "tailscale_funnel" {
  description = "Enable Tailscale funnel"
  type        = bool
  default     = false
}

variable "metabase_resources_config" {
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
      memory = "2Gi"
    }
    requests = {
      cpu    = "250m"
      memory = "256Mi"
    }
  }
}