locals {
  output_release_name      = local.release_name
  output_namespace         = var.namespace
  output_service_name      = local.output_release_name
  output_service_port      = 19120
  output_internal_url      = "http://${local.output_release_name}.${var.namespace}.svc.cluster.local:19120"
  output_default_warehouse = local.s3_warehouse_location
  output_s3_endpoint       = var.nessie_s3_endpoint
  output_s3_region         = var.nessie_s3_region
}

output "release_name" {
  description = "The name of the Helm release"
  value       = local.output_release_name
}

output "namespace" {
  description = "The namespace where Nessie is deployed"
  value       = local.output_namespace
}

output "service_name" {
  description = "The name of the Nessie service"
  value       = local.output_service_name
}

output "service_port" {
  description = "The port of the Nessie service"
  value       = local.output_service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.output_internal_url
    attributes = {
      default_warehouse = local.output_default_warehouse
      s3_endpoint       = local.output_s3_endpoint
      s3_region         = local.output_s3_region
    }
  }
}
