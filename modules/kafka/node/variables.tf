variable "namespace" {
  description = "Namespace for Kafka node pool"
  type        = string
  default     = "kafka"
}

variable "kafka_node_pool_name" {
  description = "Kafka node pool name"
  type        = string
  default     = "kafka-node-pool"
}

variable "kafka_cluster_name" {
  description = "Kafka cluster name"
  type        = string
  default     = "kafka-cluster"
}

variable "kafka_replicas" {
  description = "Number of broker replicas"
  type        = number
  default     = 1
}

variable "kafka_roles" {
  description = "Node roles (controller, broker, or both)"
  type        = list(string)
  default     = ["broker", "controller"]
}

variable "storage_size" {
  description = "Storage size for Kafka logs"
  type        = string
  default     = "10Gi"
}

variable "storage_type" {
  description = "Storage type (persistent-claim or ephemeral)"
  type        = string
  default     = "ephemeral"

  validation {
    condition     = contains(["persistent-claim", "ephemeral"], var.storage_type)
    error_message = "Must be 'persistent-claim' or 'ephemeral'"
  }
}

variable "storage_class" {
  description = "Storage class for persistent volumes"
  type        = string
  default     = "standard"
}

variable "storage_delete_claim" {
  description = "Delete PVCs when scaling down"
  type        = bool
  default     = false
}

variable "pod_run_as_user" {
  description = "Pod user ID"
  type        = number
  default     = 1001
}

variable "pod_run_as_group" {
  description = "Pod group ID"
  type        = number
  default     = 1001
}

variable "pod_fs_group" {
  description = "Pod filesystem group ID"
  type        = number
  default     = 1001
}

variable "kafka_node_resources_config" {
  description = "Resource requests/limits. Empty by default - no resources applied to avoid CPU issues on k3s."
  type = object({
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
  })
  default = null
}