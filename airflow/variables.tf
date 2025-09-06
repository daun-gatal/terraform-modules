variable "namespace" {
  description = "The namespace to deploy Airflow service into"
  type        = string
  default     = "airflow"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "airflow"
}

variable "chart_name" {
  description = "The Helm chart name for Airflow"
  type        = string
  default     = "airflow"
}

variable "chart_version" {
  description = "The Helm chart version for Airflow"
  type        = string
  default     = "1.18.0"
}

variable "airflow_db_user" {
  description = "Database username for Airflow"
  type        = string
}

variable "airflow_db_password" {
  description = "Database password for Airflow"
  type        = string
  sensitive   = true
}

variable "airflow_db_host" {
  description = "Database host for Airflow"
  type = string
}

variable "airflow_db_port" {
  description = "Database port for Airflow"
  type        = number
}

variable "airflow_db_name" {
  description = "Database name for Airflow"
  type        = string
}

variable "airflow_fernet_key" {
  description = "Fernet key for Airflow secrets encryption"
  type        = string
  sensitive   = true
}

variable "airflow_api_secret_key" {
  description = "API secret key for Airflow"
  type        = string
  sensitive   = true
}

variable "git_ssh_key_path" {
  description = "Path to Git SSH key file for DAG sync"
  type        = string
}

variable "tailscale_funnel" {
  description = "Enable Tailscale Funnel for ingress"
  type        = bool
  default     = false
}

variable "airflow_scheduler_replicas" {
  description = "Number of Airflow scheduler replicas"
  type        = number
  default     = 1
}

variable "airflow_log_retention_days" {
  description = "Log retention in days for Airflow components"
  type        = number
  default     = 7
}

variable "airflow_enable_triggerer" {
  description = "Enable Airflow triggerer component"
  type        = bool
  default     = false
}

variable "airflow_triggerer_replicas" {
  description = "Number of triggerer replicas"
  type        = number
  default     = 1
}

variable "airflow_dag_processor_replicas" {
  description = "Number of DAG processor replicas"
  type        = number
  default     = 1
}

variable "airflow_dag_processor_enabled" {
  description = "Enable DAG processor"
  type        = bool
  default     = true
}

variable "airflow_logs_bucket_name" {
  type      = string
  default   = null
  validation {
    condition     = (!var.enable_remote_logging) || (var.airflow_logs_bucket_name != null && var.airflow_logs_bucket_name != "")
    error_message = "airflow_logs_bucket_name must be set when enable_remote_logging = true."
  }
}

variable "airflow_dags_git_sync_enabled" {
  description = "Enable git-sync for DAGs"
  type        = bool
  default     = true
}

variable "airflow_dags_git_sync_repo" {
  description = "Git repository for DAGs"
  type        = string
}

variable "airflow_dags_git_sync_branch" {
  description = "Git branch for DAGs sync"
  type        = string
  default     = "main"
}

variable "airflow_dags_git_sync_rev" {
  description = "Git revision for DAGs sync"
  type        = string
  default     = "HEAD"
}

variable "airflow_dags_git_sync_ref" {
  description = "Git reference for DAGs sync"
  type        = string
  default     = ""
}

variable "airflow_dags_git_sync_subpath" {
  description = "SubPath inside DAGs repo for sync"
  type        = string
  default     = ""
}

variable "image_repository" {
  description = "Container image repository for Airflow worker"
  type        = string
  default     = "apache/airflow"
}

variable "image_tag" {
  description = "Container image tag for Airflow worker"
  type        = string
  default     = "3.0.6"
}

variable "enable_log_groomer_sidecar" {
  description = "Airflow log groomer sidecar"
  type = bool
  default = false
}

variable "enable_statsd" {
  description = "Enable statsd"
  type = bool
  default = false
}

variable "tailscale_domain" {
  description = "The domain to use for Tailscale exposure"
  type        = string
  default     = "kitty-barb.ts.net"
}

variable "aws_access_key_id" {
  description = "AWS access key ID used for the initial connection."
  type        = string
  default     = null
  sensitive   = true
  validation {
    condition     = (!var.enable_remote_logging) || (var.aws_access_key_id != null && var.aws_access_key_id != "")
    error_message = "aws_access_key_id must be set when enable_remote_logging = true."
  }
}

variable "aws_secret_access_key" {
  description = "AWS secret access key used for the initial connection."
  type        = string
  default     = null
  sensitive   = true
  validation {
    condition     = (!var.enable_remote_logging) || (var.aws_access_key_id != null && var.aws_access_key_id != "")
    error_message = "aws_access_key_id must be set when enable_remote_logging = true."
  }
}

variable "aws_region" {
  description = "AWS Region for the connection (e.g., us-east-1)."
  type        = string
  default     = "us-east-1"
}

variable "aws_endpoint_url" {
  description = "Custom S3 endpoint URL (useful for MinIO or local S3-compatible storage)."
  type        = string
  default     = null
  validation {
    condition     = (!var.enable_remote_logging) || (var.aws_access_key_id != null && var.aws_access_key_id != "")
    error_message = "aws_access_key_id must be set when enable_remote_logging = true."
  }
}

variable "airflow_default_password" {
  description = "Default password for login to Airflow"
  type = string
  sensitive = true
}

variable "enable_remote_logging" {
  type    = bool
  default = false
}