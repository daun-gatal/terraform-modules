variable "namespace" {
  description = "Kubernetes namespace for Metabase"
  type        = string
  default     = "metabase-example"
}

variable "db_host" {
  description = "PostgreSQL database host"
  type        = string
}

variable "db_user" {
  description = "PostgreSQL database username"
  type        = string
  default     = "postgres"
  sensitive   = true
}

variable "db_password" {
  description = "PostgreSQL database password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "PostgreSQL database name for Metabase"
  type        = string
  default     = "metabase"
}

variable "db_port" {
  description = "PostgreSQL database port"
  type        = number
  default     = 5432
}

variable "metabase_version" {
  description = "Metabase version tag"
  type        = string
  default     = "v0.56.x"
}
