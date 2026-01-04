locals {
  output_resource_name = kubernetes_service.metastore.metadata[0].name
  output_namespace     = kubernetes_service.metastore.metadata[0].namespace
  output_service_name  = kubernetes_service.metastore.metadata[0].name
  output_service_port  = 9083
  output_ingress_host  = ""
  output_internal_url  = "thrift://${local.output_service_name}.${local.output_namespace}.svc.cluster.local:${local.output_service_port}"
}

output "resource_name" {
  description = "The name of the main resource (Metastore)"
  value       = local.output_resource_name
}

output "namespace" {
  description = "The namespace where HMS is deployed"
  value       = local.output_namespace
}

output "service_name" {
  description = "The name of the HMS service"
  value       = local.output_service_name
}

output "service_port" {
  description = "The port of the HMS service"
  value       = local.output_service_port
}

output "ingress_host" {
  description = "The external hostname of HMS (if Ingress is enabled)"
  value       = local.output_ingress_host
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes."
  value = {
    internal_url = local.output_internal_url
    attributes = {
      config_map_name = kubernetes_config_map.hms_config.metadata[0].name
    }
  }
}
