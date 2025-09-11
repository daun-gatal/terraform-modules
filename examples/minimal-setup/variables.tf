# Minimal Setup Variables
# Variables for PostgreSQL + MinIO + Airflow integration

# Global Configuration
variable "namespace_prefix" {
  description = "Prefix for all namespace names"
  type        = string
  default     = "data-platform"
}

# PostgreSQL Configuration
variable "postgres_password" {
  description = "PostgreSQL password for Airflow metadata"
  type        = string
  sensitive   = true
}

variable "postgres_storage_size" {
  description = "PostgreSQL storage size"
  type        = string
  default     = "20Gi"
}

variable "postgres_replicas" {
  description = "Number of PostgreSQL replicas (1 for dev, 3+ for HA)"
  type        = number
  default     = 1
}

# MinIO Configuration
variable "minio_password" {
  description = "MinIO root password (minimum 8 characters)"
  type        = string
  sensitive   = true
}

variable "minio_storage_size" {
  description = "MinIO storage size per volume"
  type        = string
  default     = "50Gi"
}

variable "logs_retention_days" {
  description = "Days to retain Airflow logs in MinIO"
  type        = number
  default     = 30
}

# Airflow Configuration
variable "airflow_fernet_key" {
  description = "Airflow Fernet key for encryption (32 characters)"
  type        = string
  sensitive   = true
}

variable "airflow_api_secret_key" {
  description = "Airflow API secret key"
  type        = string
  sensitive   = true
}

variable "airflow_password" {
  description = "Airflow admin user password"
  type        = string
  sensitive   = true
}

variable "git_ssh_key_path" {
  description = "Path to SSH private key for Git DAG repository"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "dags_repo_url" {
  description = "Git repository URL for Airflow DAGs"
  type        = string
}

variable "dags_branch" {
  description = "Git branch for DAG synchronization"
  type        = string
  default     = "main"
}

variable "airflow_scheduler_replicas" {
  description = "Number of Airflow scheduler replicas"
  type        = number
  default     = 1
}

variable "airflow_enable_triggerer" {
  description = "Enable Airflow triggerer for async tasks"
  type        = bool
  default     = false
}

# Integration Configuration
variable "enable_remote_logging" {
  description = "Enable Airflow remote logging to MinIO"
  type        = bool
  default     = true
}

# Networking Configuration
variable "enable_tailscale" {
  description = "Enable Tailscale networking for services"
  type        = bool
  default     = false
}

variable "enable_public_access" {
  description = "Enable public access via Tailscale Funnel"
  type        = bool
  default     = false
}

# Resource Management
variable "enable_resource_limits" {
  description = "Enable resource allocation limits for all services"
  type        = bool
  default     = true
}

variable "postgres_cpu" {
  description = "CPU allocation for PostgreSQL namespace"
  type        = string
  default     = "2"
}

variable "postgres_memory" {
  description = "Memory allocation for PostgreSQL namespace"
  type        = string
  default     = "4Gi"
}

variable "minio_cpu" {
  description = "CPU allocation for MinIO namespace"
  type        = string
  default     = "1"
}

variable "minio_memory" {
  description = "Memory allocation for MinIO namespace"
  type        = string
  default     = "2Gi"
}

variable "airflow_cpu" {
  description = "CPU allocation for Airflow namespace"
  type        = string
  default     = "2"
}

variable "airflow_memory" {
  description = "Memory allocation for Airflow namespace"
  type        = string
  default     = "4Gi"
}
