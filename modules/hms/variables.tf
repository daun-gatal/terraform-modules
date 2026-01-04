variable "namespace" {
  description = "Namespace for HMS deployment"
  type        = string
  default     = "hms"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "hms"
}

# ============================================
# Image Configuration
# ============================================

variable "image_repository" {
  description = "Container image repository"
  type        = string
  default     = "apache/hive"
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "standalone-metastore-4.2.0"
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

# ============================================
# Database Configuration
# ============================================

variable "database_host" {
  description = "PostgreSQL host"
  type        = string
}

variable "database_port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5432
}

variable "database_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "metastore"
}

variable "database_user" {
  description = "PostgreSQL user"
  type        = string
}

variable "database_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}

# ============================================
# Component Configuration
# ============================================

variable "metastore_replicas" {
  description = "Number of Metastore replicas"
  type        = number
  default     = 1
}



# ============================================
# Object Storage Configuration (S3/MinIO)
# ============================================

variable "s3_endpoint" {
  description = "S3 endpoint URL"
  type        = string
  default     = ""
}

variable "s3_access_key" {
  description = "S3 access key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "s3_secret_key" {
  description = "S3 secret key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "hive_metastore_warehouse_dir" {
  description = "Hive Metastore warehouse directory (e.g. s3a://bucket/warehouse)"
  type        = string
  default     = "s3a://datalake/warehouse"
}

# ============================================
# Service Configuration
# ============================================

variable "tailscale_expose" {
  description = "Expose service via Tailscale"
  type        = bool
  default     = false
}



# ============================================
# Resources Configuration
# ============================================

variable "resources_config" {
  description = "Resource requests/limits per component"
  type = object({
    metastore = optional(object({
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
  })
  default = {}
}


variable "extra_env_vars" {
  description = "Map of extra environment variables"
  type        = map(string)
  default     = {}
}

variable "additional_jars" {
  description = "Map of filename to URL for additional JARs to download in the init container. Defaults include AWS SDK and Hadoop AWS."
  type        = map(string)
  default = {
    "postgresql-42.7.3.jar" = "https://jdbc.postgresql.org/download/postgresql-42.7.3.jar"
    "hadoop-aws-3.4.1.jar"  = "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.4.1/hadoop-aws-3.4.1.jar"
    "bundle-2.31.69.jar"    = "https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/2.31.69/bundle-2.31.69.jar"
  }
}
