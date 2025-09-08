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
  default     = "postgres"
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
  default     = {}
}