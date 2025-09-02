variable "namespace" {
  description = "The namespace to deploy Trino service into"
  type        = string
  default     = "trino"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "trino"
}

variable "chart_name" {
  description = "The Helm chart name for Trino"
  type        = string
  default     = "trino"
}

variable "chart_version" {
  description = "The Helm chart version for Trino"
  type        = string
  default     = "1.40.0"
}

variable "worker_count" {
  description = "The number of Trino worker replicas"
  type        = number
  default     = 1
  
}

variable "worker_query_max_memory" {
  description = "The maximum memory for Trino worker queries"
  type        = string
  default     = "4GB"
}

variable "iceberg_catalog_type" {
  description = "The type of Iceberg catalog (e.g., nessie)"
  type        = string
  default     = "nessie"
}

variable "iceberg_nessie_uri" {
  description = "The URI for the Nessie catalog with format http://<nessie-host>:<port>/api/v1"
  type        = string
}

variable "iceberg_nessie_ref" {
  description = "The Nessie reference (branch or tag) to use"
  type        = string
  default     = "main"
}

variable "iceberg_nessie_default_warehouse" {
  description = "The default warehouse path for Iceberg with format s3://<bucket>/<path>"
  type        = string
}

variable "nessie_native_s3_enabled" {
  description = "Enable native S3 support in Nessie"
  type        = bool
  default     = true
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

variable "nessie_s3_access_key" {
  description = "The access key for S3/Minio"
  type        = string
  sensitive   = true
}

variable "nessie_s3_secret_key" {
  description = "The secret key for S3/Minio"
  type        = string
  sensitive   = true
}

variable "nessie_s3_path_style_access" {
  description = "Enable path style access for S3/Minio"
  type        = bool
  default     = true
}

variable "tailscale_expose" {
  description = "Whether to expose Trino via Tailscale"
  type        = bool
  default     = true
  
}

variable "trino_admin_user" {
  description = "The Trino admin username"
  type        = string
  default     = "trino"
}

variable "trino_admin_password" {
  description = "The Trino admin password"
  type        = string
  sensitive   = true
}

variable "trino_coordinator_jvm_max_heap_size" {
  description = "The maximum heap size for the Trino coordinator JVM"
  type        = string
  default     = "6G"
}

variable "trino_coordinator_query_max_memory" {
  description = "The maximum memory for Trino coordinator queries"
  type        = string
  default     = "1GB"
}

variable "trino_worker_jvm_max_heap_size" {
  description = "The maximum heap size for the Trino worker JVM"
  type        = string
  default     = "6G"
}

variable "trino_worker_query_max_memory" {
  description = "The maximum memory for Trino worker queries"
  type        = string
  default     = "1GB"
}

variable "trino_shared_secret" {
  description = "Shared secret for internal Trino communication"
  type        = string
  sensitive   = true
}

variable "coordinator_as_worker" {
  description = "Whether the coordinator should also act as a worker"
  type        = bool
  default     = false
}