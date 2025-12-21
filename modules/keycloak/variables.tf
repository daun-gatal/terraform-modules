variable "namespace" {
  description = "Namespace for Keycloak deployment"
  type        = string
  default     = "keycloak"
}

variable "name" {
  description = "Name of the Keycloak instance"
  type        = string
  default     = "keycloak"
}

variable "service" {
  description = "Service configuration"
  type = object({
    type        = optional(string, "ClusterIP")
    annotations = optional(map(string), {})
    port = optional(object({
      name       = optional(string, "http")
      port       = optional(number, 80)
      targetPort = optional(number, 8080)
    }), {})
  })
  default = {}
}

variable "instances" {
  description = "Number of Keycloak instances"
  type        = number
  default     = 1
}

variable "db_vendor" {
  description = "Database vendor (e.g. postgres)"
  type        = string
  default     = "postgres"
}

variable "db_host" {
  description = "Database host"
  type        = string
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "db_database" {
  description = "Database name"
  type        = string
  default     = "keycloak"
}

variable "db_username_secret" {
  description = "Secret containing database username. Object with name and key."
  type = object({
    name = string
    key  = string
  })
}

variable "db_password_secret" {
  description = "Secret containing database password. Object with name and key."
  type = object({
    name = string
    key  = string
  })
}

variable "hostname" {
  description = "Hostname for Keycloak"
  type        = string
  default     = ""
}

variable "hostname_strict" {
  description = "Strict hostname checking"
  type        = bool
  default     = false
}

variable "http_enabled" {
  description = "Enable HTTP (useful if terminating TLS at Ingress)"
  type        = bool
  default     = true
}

variable "ingress_enabled" {
  description = "Enable Ingress"
  type        = bool
  default     = false
}

variable "tailscale_expose" {
  description = "Expose service via Tailscale"
  type        = bool
  default     = false
}

variable "tailscale_funnel" {
  description = "Enable Tailscale Funnel Ingress"
  type        = bool
  default     = false
}
