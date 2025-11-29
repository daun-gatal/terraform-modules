variable "namespace" {
  description = "The namespace to deploy Kafka service into"
  type        = string
  default     = "kafka"
}

variable "kafka_node_pool_name" {
  description = "Name of the Kafka Node Pool"
  type        = string
  default     = "kafka-node-pool"
}

variable "kafka_cluster_name" {
  description = "Name of the Kafka cluster"
  type        = string
  default     = "kafka-cluster"
}

variable "kafka_replicas" {
  description = "Number of Kafka broker replicas"
  type        = number
  default     = 1
}

variable "kafka_roles" {
  description = "Roles for Kafka nodes (controller, broker, or both)"
  type        = list(string)
  default     = ["broker", "controller"]
}

variable "storage_size" {
  description = "Persistent volume size for Kafka logs"
  type        = string
  default     = "10Gi"
}

variable "storage_type" {
  description = "Storage type for persistent volumes (persistent-claim, ephemeral)"
  type        = string
  default     = "ephemeral"
  
  validation {
    condition     = contains(["persistent-claim", "ephemeral"], var.storage_type)
    error_message = "Storage type must be either 'persistent-claim' or 'ephemeral'."
  }
}

variable "storage_class" {
  description = "Storage class for persistent volumes"
  type        = string
  default     = "standard"
}

variable "storage_delete_claim" {
  description = "Whether to delete persistent volume claims when scaling down"
  type        = bool
  default     = false
}

variable "pod_run_as_user" {
  description = "User ID to run Kafka pods as"
  type        = number
  default     = 1001
}

variable "pod_run_as_group" {
  description = "Group ID to run Kafka pods as"
  type        = number
  default     = 1001
}

variable "pod_fs_group" {
  description = "File system group ID for Kafka pods"
  type        = number
  default     = 1001
}

variable "kafka_node_resources_config" {
  description = "Resource configuration for Kafka pods in YAML format"
  type        = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    }) 
  })
  default     = {
    limits = {
      cpu    = "2"
      memory = "4Gi"
    }
    requests = {
      cpu    = "500m"
      memory = "1Gi"
    }
  }
}