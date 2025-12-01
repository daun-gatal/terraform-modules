variable "namespace" {
  description = "Namespace for Kafka deployment"
  type        = string
  default     = "kafka"
}

variable "kafka_cluster_name" {
  description = "Kafka cluster name"
  type        = string
  default     = "kafka-cluster"
}

variable "kafka_version" {
  description = "Kafka version"
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
  description = "Enable TLS for listeners"
  type        = bool
  default     = false
}

variable "kafka_listener_type" {
  description = "Listener type (internal or cluster-ip)"
  type        = string
  default     = "internal"

  validation {
    condition     = contains(["internal", "cluster-ip"], var.kafka_listener_type)
    error_message = "Must be 'internal' or 'cluster-ip'"
  }
}

variable "offsets_topic_replication_factor" {
  description = "Replication factor for offsets topic"
  type        = number
  default     = 3
}

variable "transaction_state_log_replication_factor" {
  description = "Replication factor for transaction log"
  type        = number
  default     = 3
}

variable "transaction_state_log_min_isr" {
  description = "Min ISR for transaction log"
  type        = number
  default     = 2
}

variable "default_replication_factor" {
  description = "Default replication factor for topics"
  type        = number
  default     = 3
}

variable "min_insync_replicas" {
  description = "Min in-sync replicas (ISR)"
  type        = number
  default     = 2
}