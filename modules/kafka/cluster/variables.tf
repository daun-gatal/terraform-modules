variable "namespace" {
  description = "The namespace to deploy Kafka service into"
  type        = string
  default     = "kafka"
}

variable "kafka_cluster_name" {
  description = "The name of the Kafka cluster"
  type        = string
  default     = "kafka-cluster"
}

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