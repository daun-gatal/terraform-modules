# Core PostgreSQL Configuration
variable "namespace" {
  description = "The namespace to deploy the PostgreSQL service into"
  type        = string
  default     = "database"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "The password for the PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "The username for the PostgreSQL database"
  type        = string
  default     = "dev"
  sensitive   = true
}

variable "db_name" {
  description = "The name of the PostgreSQL database"
  type        = string
  default     = "postgres"
}

variable "db_port" {
  description = "The port for the PostgreSQL database"
  type        = number
  default     = 5432
}

# Cluster Configuration
variable "postgres_replicas" {
  description = "Number of PostgreSQL instances (1 for single instance, 3+ for HA)"
  type        = number
  default     = 1
  
  validation {
    condition     = var.postgres_replicas >= 1
    error_message = "PostgreSQL replicas must be at least 1."
  }
}

# Storage Configuration
variable "storage_size" {
  description = "The size of the persistent volume claim"
  type        = string
  default     = "10Gi"
}

variable "storage_class_name" {
  description = "Storage class name for persistent volumes"
  type        = string
  default     = "standard"
}

# Advanced Configuration
variable "postgresql_parameters" {
  description = "Additional PostgreSQL configuration parameters"
  type        = map(string)
  default     = {
    "max_connections": "300"
  }
}

variable "image_repository" {
  description = "Image repository for Minio to be installed"
  type = string
  default = "ghcr.io/cloudnative-pg/postgresql"
}

variable "image_tag" {
  description = "Image version for Minio"
  type = string
  default = "15.4"
}

variable "extra_db_names" {
  description = "List of additional PostgreSQL databases to create"
  type        = list(string)
  default     = []
}

variable "postgres_resources_config" {
  description = "Resource configuration for PostgreSQL pods in YAML format"
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