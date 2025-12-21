output "internal_dns" {
  description = "Internal DNS of the Lakekeeper service"
  value       = "${helm_release.lakekeeper.name}.${helm_release.lakekeeper.namespace}.svc.cluster.local"
}

output "port" {
  description = "Port of the Lakekeeper service"
  value       = 8181
}
