variable "namespace" {
  description = "Kubernetes namespace for Spark"
  type        = string
  default     = "spark-example"
}

variable "worker_count" {
  description = "Number of Spark worker nodes"
  type        = number
  default     = 1
}

variable "spark_version" {
  description = "Spark version (supports 3.5.x and 4.x.x)"
  type        = string
  default     = "4.0.0"
}

variable "executor_memory" {
  description = "Memory allocation per executor for Spark Connect"
  type        = string
  default     = "2g"
}

variable "executor_cores" {
  description = "CPU cores per executor for Spark Connect"
  type        = number
  default     = 1
}

variable "max_cores" {
  description = "Maximum total cores for Spark Connect"
  type        = number
  default     = 2
}
