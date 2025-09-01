variable "namespace" {
  description = "The namespace to deploy the PostgreSQL service into"
  type        = string
  default     = "database"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "The password for the PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "The username for the PostgreSQL database"
  type        = string
  default     = "postgres"
  sensitive = true
}

variable "db_name" {
  description = "The name of the PostgreSQL database"
  type        = string
  default     = "postgres"
}

variable "db_port" {
  description = "The port for the PostgreSQL database"
  type        = number
  default     = 5432
}

variable "image_tag" {
  description = "The tag of the PostgreSQL image to use"
  type        = string
  default     = "15" 
}

variable "image" {
  description = "The PostgreSQL image to use"
  type        = string
  default     = "postgres"
}

variable "storage_size" {
  description = "The size of the persistent volume claim"
  type        = string
  default     = "5Gi"
}