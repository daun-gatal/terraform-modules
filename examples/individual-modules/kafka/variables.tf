variable "namespace" {
  description = "Kubernetes namespace for Kafka"
  type        = string
  default     = "kafka-example"
}

variable "prefix" {
  description = "Prefix for Kafka resource names"
  type        = string
  default     = "kafka"
}

variable "kafka_replicas" {
  description = "Number of Kafka broker replicas"
  type        = number
  default     = 1
}

variable "storage_type" {
  description = "Storage type (ephemeral for testing, persistent-claim for production)"
  type        = string
  default     = "ephemeral"
}

variable "enable_kafka_ui" {
  description = "Enable Kafka UI for web-based management"
  type        = bool
  default     = true
}
