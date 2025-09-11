variable "namespace" {
  description = "Kubernetes namespace for Trino"
  type        = string
  default     = "trino-example"
}

variable "worker_count" {
  description = "Number of Trino worker nodes"
  type        = number
  default     = 1
}

# Authentication
variable "admin_password" {
  description = "Trino admin user password"
  type        = string
  sensitive   = true
}

variable "shared_secret" {
  description = "Shared secret for internal Trino communication"
  type        = string
  sensitive   = true
}

# Performance settings
variable "coordinator_heap" {
  description = "Coordinator JVM max heap size"
  type        = string
  default     = "6G"
}

variable "worker_heap" {
  description = "Worker JVM max heap size"
  type        = string
  default     = "6G"
}

variable "coordinator_query_memory" {
  description = "Coordinator query max memory"
  type        = string
  default     = "1GB"
}

variable "worker_query_memory" {
  description = "Worker query max memory"
  type        = string
  default     = "4GB"
}

# Nessie catalog configuration
variable "nessie_api_uri" {
  description = "Nessie API URI (e.g., http://nessie:19120/api/v1)"
  type        = string
}

variable "nessie_branch" {
  description = "Nessie branch/ref to use"
  type        = string
  default     = "main"
}

variable "warehouse_location" {
  description = "Default warehouse location (e.g., s3://bucket/warehouse)"
  type        = string
}

# S3/MinIO configuration
variable "s3_endpoint" {
  description = "S3/MinIO endpoint URL"
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

variable "trino_version" {
  description = "Trino Helm chart version"
  type        = string
  default     = "1.40.0"
}
