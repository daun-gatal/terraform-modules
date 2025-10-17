output "spark_connect_dns" {
  description = "The DNS name for the Spark Connect service."
  value       = "${local.spark_conn_svc}.${var.namespace}.svc.cluster.local"
}

output "spark_connect_port" {
  description = "The port for the Spark Connect service."
  value       = 15002
}