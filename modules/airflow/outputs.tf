locals {
  release_name = helm_release.airflow_chart.name
  namespace    = helm_release.airflow_chart.namespace
  service_name = "${helm_release.airflow_chart.name}-web"
  service_port = 8080
  ingress_host = try(kubernetes_ingress_v1.airflow_ingress[0].spec[0].tls[0].hosts[0], "")
  internal_url = "http://${helm_release.airflow_chart.name}-web.${helm_release.airflow_chart.namespace}.svc.cluster.local:8080"
}

output "release_name" {
  description = "The name of the Helm release"
  value       = local.release_name
}

output "namespace" {
  description = "The namespace where Airflow is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "The name of the Airflow webserver service"
  value       = local.service_name
}

output "service_port" {
  description = "The port of the Airflow webserver service"
  value       = local.service_port
}

output "ingress_host" {
  description = "The external hostname of Airflow (if Ingress is enabled)"
  value       = local.ingress_host
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes = {
      secret_name = local.secret_name
    }
  }
  sensitive = true
}
