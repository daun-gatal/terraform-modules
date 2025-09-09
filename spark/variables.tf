variable "namespace" {
    description = "The namespace being used for Spark services. Should be same with the spark operator namespace."
    type = string
    default = "spark"
}

variable "prefix" {
    description = "Prefix will be used for part of Spark resources"
    type = string
    default = "spark"
}

variable "image_repository" {
    description = "Image repository of Spark"
    type = string
    default = "apache/spark"
}

variable "image_tag" {
  description = "The image tag of Spark"
  type = string
  default = "4.0.0"
}

variable "spark_k8s_opt_version" {
  description = "The api version of Spark K8s operator"
  type = string
  default = "v1beta1"
}

variable "cluster_worker_count" {
    description = "The total of worker that will be assigned to Spark"
    type = number
    default = 1
}

variable "cluster_name" {
    description = "The name of Spark cluster"
    type = string
    default = "Spark Cluster"
}

variable "tailscale_expose" {
  description = "Whether to expose the Metabase service via Tailscale"
  type        = bool
  default     = false
}

variable "spark_connect_executor_memory" {
  description = "Amount of memory allocated for Spark Connect executor"
  type        = string
  default     = "2g"
}

variable "spark_connect_executor_cores" {
  description = "Number of CPU cores allocated per Spark Connect executor"
  type        = number
  default     = 1
}

variable "spark_connect_max_cores" {
  description = "Maximum total cores allowed for Spark Connect"
  type        = number
  default     = 1
}

# Resource allocation variables
variable "cpu_allocation" {
  description = "CPU allocation for Spark namespace (requests and limits)"
  type        = string
  default     = "500m"
}

variable "memory_allocation" {
  description = "Memory allocation for Spark namespace (requests and limits)"
  type        = string
  default     = "512Mi"
}

