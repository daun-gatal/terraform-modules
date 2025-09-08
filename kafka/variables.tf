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

variable "kafka_image" {
  description = "Kafka container image"
  type        = string
  default     = "confluentinc/confluent-local"
}

variable "kafka_image_tag" {
  description = "Kafka image tag"
  type        = string
  default     = "7.8.0"
}

variable "kafka_heap_size" {
  description = "Kafka JVM heap size"
  type        = string
  default     = "1G"
}

variable "kafka_log_retention_hours" {
  description = "Kafka log retention in hours"
  type        = number
  default     = 168  # 7 days
}

variable "kafka_port" {
  description = "Kafka broker port"
  type        = number
  default     = 9092
}

variable "kafka_controller_port" {
  description = "Kafka KRaft controller port"
  type        = number
  default     = 9093
}

variable "storage_size" {
  description = "Persistent volume size for Kafka logs"
  type        = string
  default     = "10Gi"
}

variable "kafka_num_partitions" {
  description = "Default number of partitions for new topics"
  type        = number
  default     = 3
}

variable "tailscale_expose" {
  description = "Whether to expose Kafka via Tailscale"
  type        = bool
  default     = false
}

variable "enable_jmx" {
  description = "Enable JMX monitoring for Kafka"
  type        = bool
  default     = false
}

variable "jmx_port" {
  description = "JMX port for monitoring"
  type        = number
  default     = 9999
}

variable "cpu_request" {
  description = "CPU request per Kafka broker"
  type        = string
  default     = "500m"
}

variable "cpu_limit" {
  description = "CPU limit per Kafka broker"
  type        = string
  default     = "1000m"
}

variable "memory_request" {
  description = "Memory request per Kafka broker (should match heap size)"
  type        = string
  default     = "1Gi"
}

variable "memory_limit" {
  description = "Memory limit per Kafka broker"
  type        = string
  default     = "2Gi"
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

variable "kafka_ui_tailscale_funnel" {
  description = "Enable Tailscale Funnel for Kafka UI internet access"
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