# Variables for Resource Assignment Module

variable "namespace" {
  description = "The Kubernetes namespace to apply resource limits to"
  type        = string
  validation {
    condition     = length(var.namespace) > 0
    error_message = "Namespace must not be empty."
  }
}

variable "cpu" {
  description = "CPU limit and request for the namespace (same value for both)"
  type        = string
  default     = "2"
  
  validation {
    condition     = can(regex("^[0-9]+(m|$)", var.cpu))
    error_message = "CPU must be in format like '100m' or '2'."
  }
}

variable "memory" {
  description = "Memory limit and request for the namespace (same value for both)"
  type        = string
  default     = "4Gi"
  
  validation {
    condition     = can(regex("^[0-9]+(Mi|Gi|Ki|M|G|K|$)", var.memory))
    error_message = "Memory must be in format like '512Mi', '4Gi', or '1G'."
  }
}
