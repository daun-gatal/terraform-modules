# Basic Trino Example
# This example shows minimal Trino SQL query engine deployment

module "trino_example" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/trino?ref=main"
  
  # Required variables
  namespace = var.namespace
  prefix    = var.prefix
  
  # Cluster configuration
  worker_count = var.worker_count
  coordinator_as_worker = var.coordinator_as_worker
  
  # Authentication
  trino_shared_secret = var.shared_secret
  
  # JVM and performance settings
  trino_coordinator_jvm_max_heap_size = var.coordinator_heap
  trino_worker_jvm_max_heap_size     = var.worker_heap
  trino_coordinator_query_max_memory = var.coordinator_query_memory
  trino_worker_query_max_memory      = var.worker_query_memory
  
  # Network exposure
  tailscale_expose = var.tailscale_expose
  
  # Resource allocation
  enable_resource_allocation = var.enable_resource_allocation
  cpu_allocation            = var.cpu_allocation
  memory_allocation         = var.memory_allocation
  
  # Catalogs configuration
  enabled_catalogs = var.enabled_catalogs
  
  # Helm chart version
  chart_version = var.trino_version
}

# Output connection information
output "trino_connection" {
  description = "Trino connection details"
  value = {
    coordinator_dns = module.trino_example.trino_service_dns
    coordinator_port = module.trino_example.trino_service_port
    workers = var.worker_count
  }
}

output "trino_access" {
  description = "How to access Trino"
  value = {
    port_forward = "kubectl port-forward -n ${var.namespace} svc/${var.namespace}-release 8080:8080"
    ui_url = "http://localhost:8080"
    jdbc_url = "jdbc:trino://localhost:8080"
    cli_connect = "trino --server http://localhost:8080 --user trino"
  }
}
