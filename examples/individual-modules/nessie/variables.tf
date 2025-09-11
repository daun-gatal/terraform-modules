variable "namespace" {
  description = "Kubernetes namespace for Nessie"
  type        = string
  default     = "nessie-example"
}

variable "prefix" {
  description = "Prefix for Nessie resource names"
  type        = string
  default     = "nessie"
}

# PostgreSQL configuration (for Nessie metadata)
variable "postgres_host" {
  description = "PostgreSQL host for Nessie metadata"
  type        = string
}

variable "postgres_port" {
  description = "PostgreSQL port"
  type        = string
  default     = "5432"
}

variable "postgres_user" {
  description = "PostgreSQL username"
  type        = string
  sensitive   = true
}

variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}

variable "postgres_db" {
  description = "PostgreSQL database name for Nessie"
  type        = string
  default     = "nessie"
}

# S3/MinIO configuration (for data storage)
variable "s3_bucket" {
  description = "S3/MinIO bucket for data warehouse"
  type        = string
}

variable "s3_endpoint" {
  description = "S3/MinIO endpoint URL (e.g., http://minio:9000)"
  type        = string
}

variable "s3_region" {
  description = "S3/MinIO region"
  type        = string
  default     = "us-east-1"
}

variable "s3_access_key" {
  description = "S3/MinIO access key"
  type        = string
  sensitive   = true
}

variable "s3_secret_key" {
  description = "S3/MinIO secret key"
  type        = string
  sensitive   = true
}

# Warehouse configuration
variable "warehouse_path" {
  description = "Default warehouse path in S3/MinIO"
  type        = string
  default     = "warehouse"
}

variable "nessie_version" {
  description = "Nessie Helm chart version"
  type        = string
  default     = "0.104.10"
}
