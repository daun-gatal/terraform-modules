variable "namespace" {
  description = "Namespace for Gravitino deployment"
  type        = string
  default     = "gravitino"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "gravitino"
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
  default     = "gravitino"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "1.0.3"
}

variable "tailscale_expose" {
  description = "Expose service via Tailscale"
  type        = bool
  default     = false
}

# Entity store configuration
variable "entity_store" {
  description = "Entity store type"
  type        = string
  default     = "relational"
}

variable "entity_jdbc_url" {
  description = "JDBC URL for entity store"
  type        = string
  default     = "jdbc:h2"
}

variable "entity_jdbc_driver" {
  description = "JDBC driver class"
  type        = string
  default     = "org.h2.Driver"
}

variable "entity_jdbc_user" {
  description = "JDBC username"
  type        = string
  default     = "gravitino"
}

variable "entity_jdbc_password" {
  description = "JDBC password"
  type        = string
  default     = "gravitino"
  sensitive   = true
}

variable "entity_storage_path" {
  description = "Entity data storage path"
  type        = string
  default     = "/root/gravitino/data/jdbc"
}

# Auxiliary service configuration
variable "aux_service_names" {
  description = "Auxiliary services (comma-separated)"
  type        = string
  default     = "iceberg-rest"
}

variable "iceberg_rest_catalog_backend" {
  description = "Iceberg REST catalog backend"
  type        = string
  default     = "memory"
}

# Iceberg REST service configuration
variable "iceberg_rest_warehouse" {
  description = "Iceberg warehouse location (s3://bucket/path)"
  type        = string
  default     = "s3://default/warehouse"
}

# Iceberg REST JDBC configuration
variable "iceberg_rest_jdbc_user" {
  description = "Iceberg REST JDBC username"
  type        = string
  default     = "gravitino"
}

variable "iceberg_rest_jdbc_password" {
  description = "Iceberg REST JDBC password"
  type        = string
  default     = "gravitino"
  sensitive   = true
}

variable "iceberg_rest_jdbc_driver" {
  description = "Iceberg REST JDBC driver class"
  type        = string
  default     = "org.postgresql.Driver"
}

variable "iceberg_rest_jdbc_initialize" {
  description = "Initialize Iceberg meta tables"
  type        = bool
  default     = true
}

# Iceberg REST I/O configuration
variable "iceberg_rest_io_impl" {
  description = "Iceberg FileIO implementation class"
  type        = string
  default     = "org.apache.iceberg.aws.s3.S3FileIO"
}

variable "iceberg_rest_credential_providers" {
  description = "Credential providers (comma-separated)"
  type        = string
  default     = "s3-token"
}

# Iceberg REST S3 configuration
variable "iceberg_rest_s3_access_key_id" {
  description = "S3 access key ID"
  type        = string
  default     = ""
  sensitive   = true
}

variable "iceberg_rest_s3_secret_access_key" {
  description = "S3 secret access key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "iceberg_rest_s3_endpoint" {
  description = "S3 endpoint URL"
  type        = string
  default     = ""
}

variable "iceberg_rest_s3_region" {
  description = "S3 region"
  type        = string
  default     = "us-east-1"
}

variable "iceberg_rest_s3_path_style_access" {
  description = "Use S3 path-style access"
  type        = bool
  default     = true
}

# Deployment configuration
variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

# Persistence configuration
variable "persistence_enabled" {
  description = "Enable persistent storage"
  type        = bool
  default     = false
}

variable "persistence_size" {
  description = "Persistent volume size"
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
  description = "JVM memory settings"
  type        = string
  default     = "-Xms1024m -Xmx1024m -XX:MaxMetaspaceSize=512m"
}

variable "gravitino_resources_config" {
  description = "Resource requests/limits"
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