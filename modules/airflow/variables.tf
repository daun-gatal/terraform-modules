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

variable "airflow_metadata_db_conn" {
  description = "The SQLAlchemy connection for metadata DB with format postgresql://{username}:{password}@{host}:{port}/{db_name}"
  type = string
  sensitive = true
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

variable "git_auth_method" {
  description = "Authentication method for git-sync: 'ssh' or 'pat' (Personal Access Token)"
  type        = string
  default     = "ssh"

  validation {
    condition     = contains(["ssh", "pat"], var.git_auth_method)
    error_message = "Invalid git authentication method. Must be either 'ssh' or 'pat'."
  }
}

variable "git_ssh_key_path" {
  description = "Path to Git SSH key file for DAG sync (required when git_auth_method is 'ssh')"
  type        = string
  default     = null
}

variable "git_username" {
  description = "Git username for DAG sync (required when git_auth_method is 'pat')"
  type        = string
  default     = null
  sensitive   = true
}

variable "git_password" {
  description = "Git password or Personal Access Token for DAG sync (required when git_auth_method is 'pat')"
  type        = string
  default     = null
  sensitive   = true
}

variable "tailscale_expose" {
  description = "Whether to expose the Airflow service via Tailscale"
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

variable "aws_access_key_id" {
  description = "AWS access key ID used for the initial connection."
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS secret access key used for the initial connection."
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_region" {
  description = "AWS Region for the connection (e.g., us-east-1)."
  type        = string
  default     = "us-east-1"
}

variable "aws_endpoint_url" {
  description = "Custom S3 endpoint URL (useful for MinIO or local S3-compatible storage)."
  type        = string
  default     = ""
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

variable "airflow_executor" {
  description = "Executor type for Airflow. Supported: CeleryExecutor or KubernetesExecutor."
  type        = string
  default     = "KubernetesExecutor"

  validation {
    condition     = contains(["CeleryExecutor", "KubernetesExecutor"], var.airflow_executor)
    error_message = "Invalid executor type. Must be either 'CeleryExecutor' or 'KubernetesExecutor'."
  }
}


variable "airflow_worker_replicas" {
  description = "Number of Airflow worker replicas"
  type        = number
  default     = 1
}

variable "airflow_worker_keda_enabled" {
  description = "Enable KEDA for Airflow workers"
  type        = bool
  default     = false
}

variable "airflow_worker_keda_min_replicas" {
  description = "Minimum number of Airflow worker replicas when using KEDA"
  type        = number
  default     = 0
}

variable "airflow_worker_keda_max_replicas" {
  description = "Maximum number of Airflow worker replicas when using KEDA"
  type        = number
  default     = 3
}

variable "airflow_flower_credential" {
  description = "Username for Airflow Flower UI"
  type        = string
  sensitive = true
  default     = "admin:admin"
}

variable "airflow_flower_enabled" {
  description = "Enable Airflow Flower UI"
  type        = bool
  default     = false
}

variable "airflow_kubernetes_cleanup_enabled" {
  description = "Enable Kubernetes pod cleanup"
  type        = bool
  default     = false
}

variable "airflow_resources_config" {
  description = "Per-component resource configurations for Airflow components (requests and limits for CPU and RAM)"
  type = map(object({
    requests = optional(object({
      cpu = optional(string)
      ram = optional(string)
    }))
    limits = optional(object({
      cpu = optional(string)
      ram = optional(string)
    }))
  }))

  default = {
    scheduler = {
      requests = {
        cpu = "200m"
        ram = "256Mi"
      }
      limits = {
        cpu = "2000m"
        ram = "4096Mi"
      }
    }

    cleanup = {
      requests = {
        cpu = "100m"
        ram = "128Mi"
      }
      limits = {
        cpu = "500m"
        ram = "1024Mi"
      }
    }

    apiServer = {
      requests = {
        cpu = "200m"
        ram = "256Mi"
      }
      limits = {
        cpu = "500m"
        ram = "1024Mi"
      }
    }

    triggerer = {
      requests = {
        cpu = "100m"
        ram = "128Mi"
      }
      limits = {
        cpu = "500m"
        ram = "1024Mi"
      }
    }

    dagProcessor = {
      requests = {
        cpu = "100m"
        ram = "128Mi"
      }
      limits = {
        cpu = "500m"
        ram = "1024Mi"
      }
    }

    workers = {
      requests = {
        cpu = "500m"
        ram = "1024Mi"
      }
      limits = {
        cpu = "1000m"
        ram = "8192Mi"
      }
    }

    flower = {
      requests = {
        cpu = "100m"
        ram = "128Mi"
      }
      limits = {
        cpu = "500m"
        ram = "1024Mi"
      }
    }

    gitSync = {
      requests = {
        cpu = "50m"
        ram = "64Mi"
      }
      limits = {
        cpu = "500m"
        ram = "1024Mi"
      }
    }

    redis = {
      requests = {
        cpu = "100m"
        ram = "256Mi"
      }
      limits = {
        cpu = "500m"
        ram = "1024Mi"
      }
    }

    statsd = {
      requests = {
        cpu = "50m"
        ram = "64Mi"
      }
      limits = {
        cpu = "500m"
        ram = "1024Mi"
      }
    }
  }
}
