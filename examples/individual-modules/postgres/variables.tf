variable "namespace" {
  description = "Kubernetes namespace for PostgreSQL"
  type        = string
  default     = "postgres-example"
}

variable "prefix" {
  description = "Prefix for PostgreSQL resource names"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "PostgreSQL database password"
  type        = string
  sensitive   = true
}

variable "storage_size" {
  description = "Storage size per PostgreSQL instance"
  type        = string
  default     = "10Gi"
}

variable "postgres_replicas" {
  description = "Number of PostgreSQL instances (1 for single, 3+ for HA)"
  type        = number
  default     = 1
}
