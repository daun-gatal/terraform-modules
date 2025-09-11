variable "namespace" {
  description = "Kubernetes namespace for Airflow"
  type        = string
  default     = "airflow-example"
}

variable "prefix" {
  description = "Prefix for Airflow resource names"
  type        = string
  default     = "airflow"
}

variable "db_connection_string" {
  description = "PostgreSQL connection string (format: postgresql://user:pass@host:port/db)"
  type        = string
  sensitive   = true
}

variable "fernet_key" {
  description = "Airflow Fernet key for encryption (32 characters)"
  type        = string
  sensitive   = true
}

variable "api_secret_key" {
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
  description = "Path to SSH private key for Git DAG repository access"
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

variable "scheduler_replicas" {
  description = "Number of Airflow scheduler replicas"
  type        = number
  default     = 1
}

variable "enable_triggerer" {
  description = "Enable Airflow triggerer component for async tasks"
  type        = bool
  default     = false
}

variable "enable_remote_logging" {
  description = "Enable remote logging to S3/MinIO (requires additional config)"
  type        = bool
  default     = false
}
