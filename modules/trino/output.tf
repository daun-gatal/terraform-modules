output "trino_service_dns" {
  description = "The DNS name of the Trino service"
  value       = "${local.release_name}.${var.namespace}.svc.cluster.local"
}

output "trino_service_port" {
  description = "The port of the Trino service"
  value       = 8080
}

output "trino_acl" {
  description = "The access control in JSON format"
  value       = try(data.kubernetes_config_map.trino_acl.data["rules.json"], "{}")
}