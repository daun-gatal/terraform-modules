# Core Configuration
variable "namespace" {
  description = "Namespace for PostgreSQL deployment"
  type        = string
  default     = "database"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "Database username"
  type        = string
  default     = "dev"
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "postgres"
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

# Cluster Configuration
variable "postgres_replicas" {
  description = "Number of instances (1=single, 3+=HA)"
  type        = number
  default     = 1

  validation {
    condition     = var.postgres_replicas >= 1
    error_message = "Must be at least 1"
  }
}

# Storage Configuration
variable "storage_size" {
  description = "Persistent volume size"
  type        = string
  default     = "10Gi"
}

variable "storage_class_name" {
  description = "Storage class for persistent volumes"
  type        = string
  default     = "standard"
}

# Advanced Configuration
variable "postgresql_parameters" {
  description = "Additional PostgreSQL config parameters"
  type        = map(string)
  default = {
    "max_connections" : "300"
  }
}

variable "image_repository" {
  description = "Container image repository"
  type        = string
  default     = "ghcr.io/cloudnative-pg/postgresql"
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "15.4"
}

variable "extra_db_names" {
  description = "Additional databases to create"
  type        = list(string)
  default     = []
}

variable "postgres_resources_config" {
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