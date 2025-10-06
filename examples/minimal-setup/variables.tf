# Minimal Setup - Required Variables Only

# PostgreSQL Password (required)
variable "postgres_password" {
  description = "PostgreSQL password for Airflow metadata"
  type        = string
  sensitive   = true
}

# MinIO Password (required, minimum 8 characters)
variable "minio_password" {
  description = "MinIO root password (minimum 8 characters)"
  type        = string
  sensitive   = true
}

# Airflow Secrets (required)
variable "airflow_fernet_key" {
  description = "Airflow Fernet key for encryption (generate with: python -c 'from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())')"
  type        = string
  sensitive   = true
}

variable "airflow_api_secret_key" {
  description = "Airflow API secret key (generate with: openssl rand -base64 32)"
  type        = string
  sensitive   = true
}

variable "airflow_password" {
  description = "Airflow admin user password"
  type        = string
  sensitive   = true
}

# Git Configuration (required)
variable "dags_repo_url" {
  description = "Git repository URL for Airflow DAGs (use HTTPS format: https://github.com/your-org/airflow-dags.git)"
  type        = string
}

variable "dags_repo_branch" {
  description = "Git branch for Airflow DAGs"
  type        = string
  default     = "main"
}

variable "git_username" {
  description = "Git username for repository access (for PAT authentication)"
  type        = string
  sensitive   = true
}

variable "git_password" {
  description = "Git Personal Access Token for repository access"
  type        = string
  sensitive   = true
}