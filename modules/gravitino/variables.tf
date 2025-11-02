variable "namespace" {
  description = "The namespace to deploy Gravitino service into"
  type        = string
  default     = "gravitino"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "gravitino"
}

variable "chart_name" {
  description = "The Helm chart name for Gravitino"
  type        = string
  default     = "gravitino"
}

variable "chart_version" {
  description = "The Helm chart version for Gravitino"
  type        = string
  default     = "1.0.3"
}

variable "tailscale_expose" {
  description = "Whether to expose Gravitino via Tailscale"
  type        = bool
  default     = false
}

# Entity store configuration
variable "entity_store" {
  description = "The entity store to use"
  type        = string
  default     = "relational"
}

variable "entity_jdbc_url" {
  description = "The JDBC URL for the entity store"
  type        = string
  default     = "jdbc:h2"
}

variable "entity_jdbc_driver" {
  description = "The JDBC driver class name"
  type        = string
  default     = "org.h2.Driver"
}

variable "entity_jdbc_user" {
  description = "The JDBC user name"
  type        = string
  default     = "gravitino"
}

variable "entity_jdbc_password" {
  description = "The JDBC password"
  type        = string
  default     = "gravitino"
  sensitive   = true
}

variable "entity_storage_path" {
  description = "The storage path for entity data"
  type        = string
  default     = "/root/gravitino/data/jdbc"
}

# Auxiliary service configuration
variable "aux_service_names" {
  description = "Auxiliary service names, separate by ','"
  type        = string
  default     = "iceberg-rest"
}

variable "iceberg_rest_catalog_backend" {
  description = "The catalog backend for Iceberg REST service"
  type        = string
  default     = "memory"
}

# Iceberg REST service configuration
variable "iceberg_rest_warehouse" {
  description = "The warehouse directory of Iceberg in S3 bucket/Minio with format s3://bucket/path"
  type        = string
  default     = "s3://default/warehouse"
}

# Iceberg REST JDBC configuration
variable "iceberg_rest_jdbc_user" {
  description = "JDBC user for Iceberg REST service"
  type        = string
  default     = "gravitino"
}

variable "iceberg_rest_jdbc_password" {
  description = "JDBC password for Iceberg REST service"
  type        = string
  default     = "gravitino"
  sensitive   = true
}

variable "iceberg_rest_jdbc_driver" {
  description = "JDBC driver class name for Iceberg REST service"
  type        = string
  default     = "org.postgresql.Driver"
}

variable "iceberg_rest_jdbc_initialize" {
  description = "Whether to initialize the Iceberg meta tables in RDBMS"
  type        = bool
  default     = true
}

# Iceberg REST I/O configuration
variable "iceberg_rest_io_impl" {
  description = "Implementation class for Iceberg file I/O operations"
  type        = string
  default     = "org.apache.iceberg.aws.s3.S3FileIO"
}

variable "iceberg_rest_credential_providers" {
  description = "Comma-separated list of credential providers"
  type        = string
  default     = "s3-token"
}

# Iceberg REST S3 configuration
variable "iceberg_rest_s3_access_key_id" {
  description = "S3 access key ID for Iceberg REST service"
  type        = string
  default     = ""
  sensitive   = true
}

variable "iceberg_rest_s3_secret_access_key" {
  description = "S3 secret access key for Iceberg REST service"
  type        = string
  default     = ""
  sensitive   = true
}

variable "iceberg_rest_s3_endpoint" {
  description = "S3 endpoint for Iceberg REST service"
  default     = ""
  type        = string
}

variable "iceberg_rest_s3_region" {
  description = "S3 region for Iceberg REST service"
  type        = string
  default     = "us-east-1"
}

variable "iceberg_rest_s3_path_style_access" {
  description = "Whether to use path-style access instead of virtual hosted-style access"
  type        = bool
  default     = true
}

# Deployment configuration
variable "replicas" {
  description = "Number of Gravitino replicas"
  type        = number
  default     = 1
}

# Persistence configuration
variable "persistence_enabled" {
  description = "Enable persistence for Gravitino"
  type        = bool
  default     = false
}

variable "persistence_size" {
  description = "Size of persistent volume"
  type        = string
  default     = "10Gi"
}

variable "persistence_storage_class" {
  description = "Storage class for persistent volume"
  type        = string
  default     = "standard"
}

# Environment variables
variable "gravitino_home" {
  description = "Gravitino home directory"
  type        = string
  default     = "/root/gravitino"
}

variable "gravitino_mem" {
  description = "JVM memory settings for Gravitino"
  type        = string
  default     = "-Xms1024m -Xmx1024m -XX:MaxMetaspaceSize=512m"
}

variable "gravitino_resources_config" {
  description = "Resource configuration for Gravitino pods in YAML format"
  type        = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    }) 
  })
  default     = {
    limits = {
      cpu    = "2"
      memory = "3Gi"
    }
    requests = {
      cpu    = "500m"
      memory = "1Gi"
    }
  }
}