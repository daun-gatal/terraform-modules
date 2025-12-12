output "release_name" {
  description = "Name of the Helm release"
  value       = helm_release.kestra.name
}

output "release_namespace" {
  description = "Namespace of the Helm release"
  value       = helm_release.kestra.namespace
}

output "release_version" {
  description = "Version of the Helm chart"
  value       = helm_release.kestra.version
}

output "release_status" {
  description = "Status of the Helm release"
  value       = helm_release.kestra.status
}

output "service_name" {
  description = "Name of the Kestra service"
  value       = local.release_name
}

