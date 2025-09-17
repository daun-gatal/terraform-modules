variable "namespace" {
  description = "Kubernetes namespace for Gravitino"
  type        = string
  default     = "gravitino-example"
}

variable "prefix" {
  description = "Prefix for Gravitino resource names"
  type        = string
  default     = "gravitino"
}

# Entity store configuration (for Gravitino metadata)
variable "entity_jdbc_url" {
  description = "JDBC URL for Gravitino entity store (e.g., jdbc:postgresql://host:5432/gravitino)"
  type        = string
}

variable "entity_jdbc_user" {
  description = "JDBC username for Gravitino entity store"
  type        = string
  default     = "gravitino"
}

variable "entity_jdbc_password" {
  description = "JDBC password for Gravitino entity store"
  type        = string
  sensitive   = true
}

# Iceberg REST configuration (required)
variable "iceberg_warehouse" {
  description = "S3 warehouse location for Iceberg (e.g., s3://bucket/warehouse)"
  type        = string
}

variable "iceberg_jdbc_password" {
  description = "JDBC password for Iceberg REST service"
  type        = string
  sensitive   = true
}

variable "s3_endpoint" {
  description = "S3/MinIO endpoint URL (e.g., http://minio:9000)"
  type        = string
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

# Optional configurations with defaults
variable "iceberg_catalog_backend" {
  description = "Iceberg catalog backend type"
  type        = string
  default     = "jdbc"
}

variable "iceberg_jdbc_user" {
  description = "JDBC username for Iceberg REST service"
  type        = string
  default     = "gravitino"
}

variable "s3_region" {
  description = "S3/MinIO region"
  type        = string
  default     = "us-east-1"
}

variable "gravitino_version" {
  description = "Gravitino Helm chart version"
  type        = string
  default     = "1.0.3"
}
