locals {
  output_release_name = helm_release.airflow_chart.name
  output_namespace    = helm_release.airflow_chart.namespace
  output_service_name = "${helm_release.airflow_chart.name}-web"
  output_service_port = 8080
  output_ingress_host = ""
  output_internal_url = "http://${helm_release.airflow_chart.name}-web.${helm_release.airflow_chart.namespace}.svc.cluster.local:8080"
}

output "release_name" {
  description = "The name of the Helm release"
  value       = local.output_release_name
}

output "namespace" {
  description = "The namespace where Airflow is deployed"
  value       = local.output_namespace
}

output "service_name" {
  description = "The name of the Airflow webserver service"
  value       = local.output_service_name
}

output "service_port" {
  description = "The port of the Airflow webserver service"
  value       = local.output_service_port
}

output "ingress_host" {
  description = "The external hostname of Airflow (if Ingress is enabled)"
  value       = local.output_ingress_host
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.output_internal_url
    attributes = {
      secret_name = local.secret_name
    }
  }
  sensitive = true
}
