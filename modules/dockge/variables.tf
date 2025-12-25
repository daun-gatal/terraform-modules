variable "namespace" {
  description = "The namespace to deploy Dockge into."
  type        = string
  default     = "dind"
}

variable "dockge_image" {
  description = "The Dockge Docker image."
  type        = string
  default     = "louislam/dockge:1.5.0"
}

variable "dind_image" {
  description = "The Docker-in-Docker sidecar image."
  type        = string
  default     = "docker:29.1.3-dind"
}

variable "dockge_data_size" {
  description = "Size of the volume for Dockge data (stacks)."
  type        = string
  default     = "50Gi"
}

variable "dind_storage_size" {
  description = "Size of the volume for Docker images."
  type        = string
  default     = "50Gi"
}

variable "storage_class_name" {
  description = "Storage class for the PVCs. Leave null for default."
  type        = string
  default     = "standard"
}

variable "service_port" {
  description = "The port to expose the service on."
  type        = number
  default     = 5001
}

variable "container_port" {
  description = "The port the container listens on."
  type        = number
  default     = 5001
}

variable "service_type" {
  description = "The type of service to create."
  type        = string
  default     = "ClusterIP"
  validation {
    condition     = contains(["ClusterIP", "NodePort", "LoadBalancer"], var.service_type)
    error_message = "Service type must be ClusterIP, NodePort, or LoadBalancer."
  }
}

variable "dockge_env" {
  description = "Additional environment variables for the Dockge container."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "dind_env" {
  description = "Additional environment variables for the DinD container."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "resources" {
  description = "Resource requests and limits for the containers."
  type = map(object({
    requests = optional(map(string))
    limits   = optional(map(string))
  }))
  default = {}
}

variable "tailscale_expose" {
  description = "Whether to expose the service via Tailscale."
  type        = bool
  default     = false
}

variable "tailscale_hostname" {
  description = "The hostname to use for Tailscale."
  type        = string
  default     = "dockge-web-int"
}

variable "tailscale_funnel" {
  description = "Expose service via Tailscale Funnel (public ingress)"
  type        = bool
  default     = false
}

variable "ingress_host" {
  description = "Hostname for the Ingress"
  type        = string
  default     = "dockge-web-ext"
}
