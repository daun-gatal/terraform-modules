output "keycloak_internal_dns" {
  description = "Internal DNS name of the Keycloak service"
  value       = "${kubernetes_service.keycloak.metadata[0].name}.${var.namespace}.svc.cluster.local"
}

output "keycloak_internal_port" {
  description = "Keycloak service HTTP port"
  value       = var.service.port.port
}
