# ============================================
# Core Configuration
# ============================================

variable "namespace" {
  description = "Namespace for Airflow deployment"
  type        = string
  default     = "airflow"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "airflow"
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
  default     = "airflow"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "1.18.0"
}

# ============================================
# Image Configuration
# ============================================

variable "image_repository" {
  description = "Container image repository"
  type        = string
  default     = "apache/airflow"
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "3.0.6"
}

# ============================================
# Authentication & Secrets
# ============================================

variable "airflow_metadata_db_conn" {
  description = "SQLAlchemy connection string (postgresql://user:pass@host:port/db)"
  type        = string
  sensitive   = true
}

variable "airflow_fernet_key" {
  description = "Fernet key for secrets encryption"
  type        = string
  sensitive   = true
}

variable "airflow_api_secret_key" {
  description = "API secret key"
  type        = string
  sensitive   = true
}

variable "airflow_default_password" {
  description = "Default webserver password"
  type        = string
  sensitive   = true
}

# ============================================
# Git Sync Configuration
# ============================================

variable "git_auth_method" {
  description = "Git auth method (ssh or pat)"
  type        = string
  default     = "ssh"

  validation {
    condition     = contains(["ssh", "pat"], var.git_auth_method)
    error_message = "Must be 'ssh' or 'pat'"
  }
}

variable "git_ssh_key_path" {
  description = "Path to SSH key file (required for ssh auth)"
  type        = string
  default     = null
}

variable "git_username" {
  description = "Git username (required for pat auth)"
  type        = string
  default     = null
  sensitive   = true
}

variable "git_password" {
  description = "Git password or PAT (required for pat auth)"
  type        = string
  default     = null
  sensitive   = true
}

variable "airflow_dags_git_sync_enabled" {
  description = "Enable git-sync for DAGs"
  type        = bool
  default     = true
}

variable "airflow_dags_git_sync_repo" {
  description = "Git repository URL for DAGs"
  type        = string
}

variable "airflow_dags_git_sync_branch" {
  description = "Git branch to sync"
  type        = string
  default     = "main"
}

variable "airflow_dags_git_sync_rev" {
  description = "Git revision to sync"
  type        = string
  default     = "HEAD"
}

variable "airflow_dags_git_sync_ref" {
  description = "Git reference to sync"
  type        = string
  default     = ""
}

variable "airflow_dags_git_sync_subpath" {
  description = "Subpath within DAGs repo"
  type        = string
  default     = ""
}

# ============================================
# Executor Configuration
# ============================================

variable "airflow_executor" {
  description = "Executor type (CeleryExecutor or KubernetesExecutor)"
  type        = string
  default     = "KubernetesExecutor"

  validation {
    condition     = contains(["CeleryExecutor", "KubernetesExecutor"], var.airflow_executor)
    error_message = "Must be 'CeleryExecutor' or 'KubernetesExecutor'"
  }
}

# ============================================
# Scheduler Configuration
# ============================================

variable "airflow_scheduler_replicas" {
  description = "Number of scheduler replicas"
  type        = number
  default     = 1
}

# ============================================
# Triggerer Configuration
# ============================================

variable "airflow_enable_triggerer" {
  description = "Enable triggerer component"
  type        = bool
  default     = false
}

variable "airflow_triggerer_replicas" {
  description = "Number of triggerer replicas"
  type        = number
  default     = 1
}

# ============================================
# DAG Processor Configuration
# ============================================

variable "airflow_dag_processor_enabled" {
  description = "Enable DAG processor"
  type        = bool
  default     = true
}

variable "airflow_dag_processor_replicas" {
  description = "Number of DAG processor replicas"
  type        = number
  default     = 1
}

# ============================================
# Worker Configuration
# ============================================

variable "airflow_worker_replicas" {
  description = "Number of worker replicas"
  type        = number
  default     = 1
}

variable "airflow_worker_keda_enabled" {
  description = "Enable KEDA autoscaling for workers"
  type        = bool
  default     = false
}

variable "airflow_worker_keda_min_replicas" {
  description = "Min worker replicas with KEDA"
  type        = number
  default     = 0
}

variable "airflow_worker_keda_max_replicas" {
  description = "Max worker replicas with KEDA"
  type        = number
  default     = 3
}

# ============================================
# Flower Configuration
# ============================================

variable "airflow_flower_enabled" {
  description = "Enable Flower monitoring UI"
  type        = bool
  default     = false
}

variable "airflow_flower_credential" {
  description = "Flower UI credentials (user:pass)"
  type        = string
  sensitive   = true
  default     = "admin:admin"
}

# ============================================
# Logging Configuration
# ============================================

variable "airflow_log_retention_days" {
  description = "Log retention period in days"
  type        = number
  default     = 7
}

variable "enable_log_groomer_sidecar" {
  description = "Enable log groomer sidecar"
  type        = bool
  default     = false
}

variable "enable_remote_logging" {
  description = "Enable remote logging to S3"
  type        = bool
  default     = false
}

variable "airflow_logs_bucket_name" {
  description = "S3 bucket name for remote logs"
  type        = string
  default     = null
}

# ============================================
# Cleanup Configuration
# ============================================

variable "airflow_kubernetes_cleanup_enabled" {
  description = "Enable Kubernetes pod cleanup job"
  type        = bool
  default     = false
}

# ============================================
# StatsD Configuration
# ============================================

variable "enable_statsd" {
  description = "Enable StatsD metrics"
  type        = bool
  default     = false
}

# ============================================
# AWS/S3 Configuration
# ============================================

variable "aws_access_key_id" {
  description = "AWS access key ID"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region (e.g., us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "aws_endpoint_url" {
  description = "Custom S3 endpoint URL (for MinIO/S3-compatible storage)"
  type        = string
  default     = ""
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

variable "airflow_resources_config" {
  description = "Resource requests/limits per component. Empty by default - no resources applied to avoid CPU issues on k3s."
  type = object({
    scheduler = optional(object({
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
    apiServer = optional(object({
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
    triggerer = optional(object({
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
    dagProcessor = optional(object({
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
    workers = optional(object({
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
    flower = optional(object({
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
    cleanup = optional(object({
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
    gitSync = optional(object({
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
    redis = optional(object({
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
    statsd = optional(object({
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

# ============================================
# Additional Helm Values
# ============================================

variable "values" {
  description = "Additional Helm values to merge (supports all chart values). These values will override any defaults."
  type        = any
  default     = {}
}

# ============================================
# API Server Configuration
# ============================================
variable "airflow_api_server_config" {
  description = "Additional API server configuration options"
  type        = string
  default     = ""
}
