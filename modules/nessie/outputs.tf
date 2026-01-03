locals {
  release_name      = local.release_name
  namespace         = var.namespace
  service_name      = local.release_name
  service_port      = 19120
  internal_url      = "http://${local.release_name}.${var.namespace}.svc.cluster.local:19120"
  default_warehouse = local.s3_warehouse_location
  s3_endpoint       = var.nessie_s3_endpoint
  s3_region         = var.nessie_s3_region
}

output "release_name" {
  description = "The name of the Helm release"
  value       = local.release_name
}

output "namespace" {
  description = "The namespace where Nessie is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "The name of the Nessie service"
  value       = local.service_name
}

output "service_port" {
  description = "The port of the Nessie service"
  value       = local.service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes = {
      default_warehouse = local.default_warehouse
      s3_endpoint       = local.s3_endpoint
      s3_region         = local.s3_region
    }
  }
}
