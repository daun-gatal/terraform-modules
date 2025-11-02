variable "namespace" {
  description = "The namespace to deploy Kafka service into"
  type        = string
  default     = "kafka"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "kafka"
}

# Kafka Cluster Configuration
variable "kafka_version" {
  description = "Kafka version to deploy"
  type        = string
  default     = "4.0.0"
}

variable "kafka_metadata_version" {
  description = "Kafka metadata version (KRaft)"
  type        = string
  default     = "4.0-IV3"
}

variable "kafka_replicas" {
  description = "Number of Kafka broker replicas"
  type        = number
  default     = 3
}

variable "kafka_roles" {
  description = "Roles for Kafka nodes (controller, broker, or both)"
  type        = list(string)
  default     = ["controller", "broker"]
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

# Security Context
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

variable "kafka_port" {
  description = "Kafka broker port"
  type        = number
  default     = 9092
}

variable "kafka_tls_enabled" {
  description = "Enable TLS for Kafka listeners"
  type        = bool
  default     = false
}

variable "kafka_listener_type" {
  description = "Kafka listener type (internal, cluster-ip)"
  type        = string
  default     = "internal"

  validation {
    condition     = contains(["internal", "cluster-ip"], var.kafka_listener_type)
    error_message = "kafka_listener_type must be either 'internal' or 'cluster-ip'."
  }
}


# Kafka Configuration Parameters
variable "offsets_topic_replication_factor" {
  description = "Replication factor for the offsets topic"
  type        = number
  default     = 3
}

variable "transaction_state_log_replication_factor" {
  description = "Replication factor for transaction state log"
  type        = number
  default     = 3
}

variable "transaction_state_log_min_isr" {
  description = "Minimum in-sync replicas for transaction state log"
  type        = number
  default     = 2
}

variable "default_replication_factor" {
  description = "Default replication factor for new topics"
  type        = number
  default     = 3
}

variable "min_insync_replicas" {
  description = "Minimum number of in-sync replicas"
  type        = number
  default     = 2
}

variable "tailscale_expose" {
  description = "Whether to expose Kafka via Tailscale"
  type        = bool
  default     = false
}

# Kafka UI Variables
variable "enable_kafka_ui" {
  description = "Enable Kafka UI (kafkabat/kafka-ui) for cluster management"
  type        = bool
  default     = false
}

variable "kafka_ui_image" {
  description = "Kafka UI container image"
  type        = string
  default     = "ghcr.io/kafbat/kafka-ui"
}

variable "kafka_ui_image_tag" {
  description = "Kafka UI image tag"
  type        = string
  default     = "e3ba25f"
}

variable "kafka_ui_port" {
  description = "Kafka UI service port"
  type        = number
  default     = 8080
}

variable "kafka_ui_tailscale_expose" {
  description = "Whether to expose Kafka UI via Tailscale"
  type        = bool
  default     = false
}

variable "kafka_ui_auth_enabled" {
  description = "Enable basic authentication for Kafka UI"
  type        = bool
  default     = false
}

variable "kafka_ui_auth_username" {
  description = "Username for Kafka UI basic authentication"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "kafka_ui_auth_password" {
  description = "Password for Kafka UI basic authentication"
  type        = string
  default     = ""
  sensitive   = true

  validation {
    condition     = var.kafka_ui_auth_password == "" || length(var.kafka_ui_auth_password) >= 8
    error_message = "Password must be at least 8 characters long when provided."
  }
}

variable "kafka_ui_secret_name" {
  description = "Name of the Kubernetes Secret containing Kafka UI environment variables"
  type        = string
  default     = "kafka-ui-secret" # or override via tfvars
}

variable "kafka_resources_config" {
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

variable "kafka_ui_resources_config" {
  description = "Resource configuration for Kafka UI pods in YAML format"
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
      cpu    = "1"
      memory = "1Gi"
    }
    requests = {
      cpu    = "250m"
      memory = "256Mi"
    }
  }
}