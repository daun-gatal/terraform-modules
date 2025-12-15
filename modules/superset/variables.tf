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

variable "tailscale_funnel" {
  description = "Enable Tailscale Funnel for the Superset service"
  type        = bool
  default     = false
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
  description = "Resource requests/limits per component. Empty by default - no resources applied to avoid CPU issues on k3s."
  type = map(object({
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
  }))

  default = {}
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
# Autoscaling Configuration
# ============================================
variable "enable_superset_autoscaling" {
  description = "Enable autoscaling for Superset web server and Celery worker"
  type        = bool
  default     = false
}

variable "superset_autoscaling_min_replicas" {
  description = "Minimum number of replicas for autoscaling"
  type        = number
  default     = 1
}

variable "superset_autoscaling_max_replicas" {
  description = "Maximum number of replicas for autoscaling"
  type        = number
  default     = 2
}

variable "superset_autoscaling_target_cpu_utilization_percentage" {
  description = "Target CPU utilization percentage for autoscaling"
  type        = number
  default     = 90
}

variable "superset_autoscaling_target_memory_utilization_percentage" {
  description = "Target Memory utilization percentage for autoscaling"
  type        = number
  default     = 90
}

# ============================================
# Additional Helm Values
# ============================================
variable "values" {
  description = "Additional Helm values to merge (supports all chart values). These values will override any defaults."
  type        = any
  default     = {}
}
