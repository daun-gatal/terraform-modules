variable "namespace" {
  description = "The namespace to deploy Nessie service into"
  type        = string
  default     = "nessie"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "nessie"
}

variable "chart_name" {
  description = "The Helm chart name for Nessie"
  type        = string
  default     = "nessie"
}

variable "chart_version" {
  description = "The Helm chart version for Nessie"
  type        = string
  default     = "0.104.10"
}

variable "nessie_jdbc_username" {
  description = "The username for Nessie JDBC connection"
  type        = string
  sensitive = true
}

variable "nessie_jdbc_password" {
  description = "The password for Nessie JDBC connection"
  type        = string
  sensitive = true
}

variable "nessie_jdbc_url" {
  description = "The JDBC URL for Nessie"
  type        = string
}

variable "nessie_jdbc_port" {
  description = "The JDBC port for Nessie"
  type        = string
}

variable "nessie_database_name" {
  description = "The database name for Nessie"
  type        = string
}

variable "nessie_default_warehouse" {
  description = "The default warehouse path for Nessie"
  type        = string
  default     = "warehouse"
}

variable "nessie_s3_bucket" {
  description = "The default S3/Minio bucket name for Nessie"
  type        = string
}

variable "nessie_s3_endpoint" {
  description = "The S3/Minio endpoint for Nessie with format http://host:port"
  type        = string
}

variable "nessie_s3_region" {
  description = "The S3/Minio region for Nessie"
  type        = string
  default     = "us-east-1"
}

variable "nessie_s3_access_key_name" {
  description = "The S3/Minio access key name for Nessie"
  type        = string
  sensitive = true
}

variable "nessie_s3_access_key_secret" {
  description = "The S3/Minio secret key for Nessie"
  type        = string
  sensitive = true
}

variable "tailscale_expose" {
  description = "Whether to expose the Nessie service via Tailscale"
  type        = bool
  default     = true
}