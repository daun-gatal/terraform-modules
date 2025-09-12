variable "namespace" {
  description = "Kubernetes namespace for Trino"
  type        = string
  default     = "trino-example"
}

variable "prefix" {
  description = "Prefix for Trino resource names"
  type        = string
  default     = "trino"
}

variable "worker_count" {
  description = "Number of Trino worker nodes"
  type        = number
  default     = 1
}

variable "coordinator_as_worker" {
  description = "Whether the coordinator should also act as a worker"
  type        = bool
  default     = false
}

# Authentication
variable "shared_secret" {
  description = "Shared secret for internal Trino communication"
  type        = string
  sensitive   = true
}

# Performance settings
variable "coordinator_heap" {
  description = "Coordinator JVM max heap size"
  type        = string
  default     = "6G"
}

variable "worker_heap" {
  description = "Worker JVM max heap size"
  type        = string
  default     = "6G"
}

variable "coordinator_query_memory" {
  description = "Coordinator query max memory"
  type        = string
  default     = "1GB"
}

variable "worker_query_memory" {
  description = "Worker query max memory"
  type        = string
  default     = "4GB"
}

# Network exposure
variable "tailscale_expose" {
  description = "Whether to expose Trino via Tailscale"
  type        = bool
  default     = false
}

# Resource allocation
variable "enable_resource_allocation" {
  description = "Enable resource allocation for namespace"
  type        = bool
  default     = false
}

variable "cpu_allocation" {
  description = "CPU allocation for Trino namespace (requests and limits)"
  type        = string
  default     = "4"
}

variable "memory_allocation" {
  description = "Memory allocation for Trino namespace (requests and limits)"
  type        = string
  default     = "8Gi"
}

# Catalog configuration
variable "enabled_catalogs" {
  description = "List of catalogs to enable in Trino"
  type = list(object({
    name      = string       # catalog name in Trino
    params    = map(string)  # raw key=value pairs for catalog configuration
  }))
  
  default = []
}

variable "trino_version" {
  description = "Trino Helm chart version"
  type        = string
  default     = "1.40.0"
}
