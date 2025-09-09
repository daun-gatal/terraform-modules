variable "namespace" {
  description = "The namespace to deploy the Metabase service into"
  type        = string
  default     = "metabase"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "metabase"
}

variable "metabase_db_password" {
  description = "The password for the Metabase database"
  type        = string
  sensitive   = true
}

variable "metabase_db_user" {
  description = "The username for the Metabase database"
  type        = string
  default     = "postgres"
  sensitive = true
}

variable "metabase_db_name" {
  description = "The name of the Metabase database"
  type        = string
  default     = "postgres"
}

variable "metabase_db_port" {
  description = "The port for the Metabase database"
  type        = number
  default     = 5432
}

variable "metabase_db_host" {
  description = "The host for the Metabase database"
  type        = string
}

variable "image_tag" {
  description = "The tag of the Metabase image to use"
  type        = string
  default     = "v0.56.x" 
}

variable "image" {
  description = "The Metabase image to use"
  type        = string
  default     = "metabase/metabase"
}

variable "tailscale_expose" {
  description = "Whether to expose the Metabase service via Tailscale"
  type        = bool
  default     = false
}

variable "tailscale_funnel" {
  description = "Whether to enable Tailscale funnel"
  type        = bool
  default     = false
}

# Resource allocation variables
variable "cpu_allocation" {
  description = "CPU allocation for Metabase namespace (requests and limits)"
  type        = string
  default     = "500m"
}

variable "memory_allocation" {
  description = "Memory allocation for Metabase namespace (requests and limits)"
  type        = string
  default     = "512Mi"
}

variable "enable_resource_allocation" {
  description = "Enable resource allocation for namespace"
  type = bool
  default = false
}