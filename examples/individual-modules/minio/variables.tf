variable "namespace" {
  description = "Kubernetes namespace for MinIO"
  type        = string
  default     = "minio-example"
}

variable "tenant_name" {
  description = "MinIO tenant name (used in resource naming)"
  type        = string
  default     = "dev-minio"
}

variable "minio_password" {
  description = "MinIO root password (minimum 8 characters)"
  type        = string
  sensitive   = true
}

variable "storage_size" {
  description = "Storage size per volume"
  type        = string
  default     = "5Gi"
}

variable "buckets" {
  description = "List of buckets to create"
  type = list(object({
    name                   = string
    region                 = optional(string, "us-east-1")
    expire_days            = optional(number, null)
    noncurrent_expire_days = optional(number, null)
  }))
  default = [
    {
      name = "example-bucket"
    },
    {
      name        = "logs-bucket"
      expire_days = 7
    }
  ]
}
