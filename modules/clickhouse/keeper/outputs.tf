locals {
  service_name = kubernetes_service.keeper.metadata[0].name
  namespace    = kubernetes_service.keeper.metadata[0].namespace
  client_port  = 2181
  raft_port    = 9444
  internal_url = "${local.service_name}.${local.namespace}.svc.cluster.local:${local.client_port}"
}

output "service_name" {
  description = "Keeper Headless Service Name"
  value       = local.service_name
}

output "namespace" {
  description = "Namespace where Keeper is deployed"
  value       = local.namespace
}

output "client_port" {
  description = "Keeper Client Port"
  value       = local.client_port
}

output "config" {
  description = "Complementary configuration object"
  value = {
    internal_url = local.internal_url
    attributes = {
      raft_port = local.raft_port
    }
  }
}
