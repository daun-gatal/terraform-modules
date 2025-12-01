variable "namespace" {
  description = "Namespace for Nessie deployment"
  type        = string
  default     = "nessie"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "nessie"
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
  default     = "nessie"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "0.104.10"
}

variable "nessie_jdbc_username" {
  description = "JDBC username"
  type        = string
  sensitive   = true
}

variable "nessie_jdbc_password" {
  description = "JDBC password"
  type        = string
  sensitive   = true
}

variable "nessie_jdbc_url" {
  description = "JDBC URL"
  type        = string
}

variable "nessie_jdbc_port" {
  description = "JDBC port"
  type        = string
}

variable "nessie_database_name" {
  description = "Database name"
  type        = string
}

variable "nessie_default_warehouse" {
  description = "Default warehouse path"
  type        = string
  default     = "warehouse"
}

variable "nessie_s3_bucket" {
  description = "S3/MinIO bucket name"
  type        = string
}

variable "nessie_s3_endpoint" {
  description = "S3/MinIO endpoint (http://host:port)"
  type        = string
}

variable "nessie_s3_region" {
  description = "S3/MinIO region"
  type        = string
  default     = "us-east-1"
}

variable "nessie_s3_access_key_name" {
  description = "S3/MinIO access key"
  type        = string
  sensitive   = true
}

variable "nessie_s3_access_key_secret" {
  description = "S3/MinIO secret key"
  type        = string
  sensitive   = true
}

variable "tailscale_expose" {
  description = "Expose service via Tailscale"
  type        = bool
  default     = false
}

variable "nessie_resources_config" {
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
      memory = "4Gi"
    }
    requests = {
      cpu    = "250m"
      memory = "256Mi"
    }
  }
}