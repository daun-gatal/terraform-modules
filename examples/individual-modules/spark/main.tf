# Basic Spark Example
# This example shows minimal Apache Spark cluster deployment

module "spark_example" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/spark?ref=main"
  
  # Required variables
  namespace = var.namespace
  prefix    = var.prefix
  
  # Spark cluster configuration
  cluster_worker_count = var.worker_count
  image_tag           = var.spark_version
  
  # Spark Connect configuration (for Spark 4.x)
  spark_connect_executor_memory = var.executor_memory
  spark_connect_executor_cores  = var.executor_cores
  spark_connect_max_cores      = var.max_cores
}

# Output cluster information
output "spark_cluster_info" {
  description = "Spark cluster access information"
  value = {
    namespace     = var.namespace
    workers       = var.worker_count
    spark_version = var.spark_version
  }
}

output "spark_access" {
  description = "How to access Spark UI and Connect"
  value = {
    ui_port_forward = "kubectl port-forward -n ${var.namespace} svc/${var.namespace}-spark-cluster-master-svc 8080:8080"
    ui_url = "http://localhost:8080"
    connect_port_forward = split(".", var.spark_version)[0] >= "4" ? "kubectl port-forward -n ${var.namespace} svc/${var.namespace}-spark-conn-service 15002:15002" : "Spark Connect not available (requires Spark 4.x)"
  }
}
