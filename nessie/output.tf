output "nessie_service_dns" {
  value       = "${helm_release.nessie.name}.${kubernetes_namespace.nessie.metadata[0].name}.svc.cluster.local"
  description = "The Nessie service DNS name"
}

output "nessie_service_port" {
  value       = 19120
  description = "The Nessie service port"
}