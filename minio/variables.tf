variable "namespace" {
  description = "The namespace to deploy MinIO service into"
  type        = string
  default     = "minio"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "minio"
}

variable "image_tag" {
  description = "The tag of the PostgreSQL image to use"
  type        = string
  default     = "RELEASE.2025-07-23T15-54-02Z" 
}

variable "image" {
  description = "The PostgreSQL image to use"
  type        = string
  default     = "minio/minio"
}

variable "minio_root_user" {
  description = "The root user for MinIO"
  type        = string
  default     = "minioadmin"
  sensitive = true
}

variable "minio_root_password" {
  description = "The root password for MinIO"
  type        = string
  sensitive = true
}

variable "minio_console_port" {
  description = "The port for MinIO console"
  type        = number
  default     = 9090
}

variable "minio_api_port" {
  description = "The port for MinIO API"
  type        = number
  default     = 9000
}

variable "storage_size" {
  description = "The size of the persistent storage for MinIO"
  type        = string
  default     = "10Gi"
}