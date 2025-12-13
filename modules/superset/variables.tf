# ============================================
# Core Configuration
# ============================================

variable "namespace" {
  description = "Namespace for Superset deployment"
  type        = string
  default     = "superset"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "superset"
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
  default     = "superset"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "0.14.1"
}

# ============================================
# Image Configuration
# ============================================

variable "image_repository" {
  description = "Container image repository"
  type        = string
  default     = "apachesuperset.docker.scarf.sh/apache/superset"
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "5.0.0"
}

variable "image_pull_policy" {
  description = "Container image pull policy"
  type        = string
  default     = "IfNotPresent"

  validation {
    condition     = contains(["Always", "IfNotPresent", "Never"], var.image_pull_policy)
    error_message = "Must be 'Always', 'IfNotPresent', or 'Never'"
  }
}

# ============================================
# Authentication & Secrets
# ============================================
variable "admin_password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}

variable "oauth_config" {
  description = "OAuth configuration for Superset authentication"
  type        = string
  default     = ""
  sensitive   = true
}

variable "superset_secret_name" {
  description = "Name of an existing Kubernetes Secret for Superset. The secret must contain the following env vars: DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASS, REDIS_HOST, REDIS_PORT, REDIS_PROTO, SUPERSET_SECRET_KEY."
  type        = string
  default     = "superset-custom-secret"
}


# ============================================
# Database Configuration
# ============================================
variable "use_external_database" {
  description = "Use external PostgreSQL instead of built-in"
  type        = bool
  default     = false
}

# ============================================
# Redis Configuration
# ============================================

variable "use_external_redis" {
  description = "Use external Redis instead of built-in"
  type        = bool
  default     = false
}

# ============================================
# Admin User Configuration
# ============================================

variable "admin_username" {
  description = "Admin username"
  type        = string
  default     = "admin"
}

variable "admin_firstname" {
  description = "Admin first name"
  type        = string
  default     = "Admin"
}

variable "admin_lastname" {
  description = "Admin last name"
  type        = string
  default     = "User"
}

variable "admin_email" {
  description = "Admin email address"
  type        = string
  default     = "admin@superset.com"
}

# ============================================
# Superset Node Configuration
# ============================================
variable "superset_node_replicas" {
  description = "Number of Superset web server replicas"
  type        = number
  default     = 1
}

variable "service_type" {
  description = "Kubernetes service type"
  type        = string
  default     = "ClusterIP"

  validation {
    condition     = contains(["ClusterIP", "NodePort", "LoadBalancer"], var.service_type)
    error_message = "Must be 'ClusterIP', 'NodePort', or 'LoadBalancer'"
  }
}

variable "superset_port" {
  description = "Port for Superset service"
  type        = number
  default     = 8088
}

# ============================================
# Celery Configuration
# ============================================
variable "enable_celery_worker" {
  description = "Enable Celery worker for async queries"
  type        = bool
  default     = false
}

variable "celery_worker_replicas" {
  description = "Number of Celery worker replicas"
  type        = number
  default     = 1
}

variable "enable_celery_beat" {
  description = "Enable Celery beat scheduler"
  type        = bool
  default     = false
}

variable "enable_celery_flower" {
  description = "Enable Celery Flower monitoring UI"
  type        = bool
  default     = false
}

# ============================================
# Websocket Configuration
# ============================================
variable "enable_websockets" {
  description = "Enable websocket server for real-time features"
  type        = bool
  default     = false
}

# ============================================
# Cache Configuration
# ============================================
variable "cache_default_timeout" {
  description = "Default cache timeout in seconds"
  type        = number
  default     = 300
}

variable "cache_key_prefix" {
  description = "Cache key prefix"
  type        = string
  default     = "superset_"
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
variable "superset_resources_config" {
  description = "Resource requests/limits per component"
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
    supersetNode = {
      requests = {
        cpu = "200m"
        ram = "256Mi"
      }
      limits = {
        cpu = "1000m"
        ram = "2048Mi"
      }
    }

    supersetWorker = {
      requests = {
        cpu = "200m"
        ram = "256Mi"
      }
      limits = {
        cpu = "1000m"
        ram = "2048Mi"
      }
    }

    supersetCeleryBeat = {
      requests = {
        cpu = "100m"
        ram = "128Mi"
      }
      limits = {
        cpu = "500m"
        ram = "512Mi"
      }
    }

    supersetCeleryFlower = {
      requests = {
        cpu = "100m"
        ram = "128Mi"
      }
      limits = {
        cpu = "500m"
        ram = "512Mi"
      }
    }

    supersetWebsockets = {
      requests = {
        cpu = "100m"
        ram = "128Mi"
      }
      limits = {
        cpu = "500m"
        ram = "512Mi"
      }
    }

    initJob = {
      requests = {
        cpu = "100m"
        ram = "128Mi"
      }
      limits = {
        cpu = "500m"
        ram = "512Mi"
      }
    }
  }
}

# ============================================
# Bootstrap Configuration
# ============================================
variable "bootstrap_pip_packages" {
  description = "List of pip packages to install during bootstrap (e.g., database drivers, connectors)"
  type        = list(string)
  default     = []
}

# ============================================
# Additional Helm Values
# ============================================
variable "values" {
  description = "Additional Helm values to merge (supports all chart values). These values will override any defaults."
  type        = any
  default     = {}
}
