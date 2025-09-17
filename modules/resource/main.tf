# Create a LimitRange for the namespace to set default CPU/Memory
resource "kubernetes_limit_range" "namespace_limits" {
  metadata {
    name      = "${var.namespace}-limit-range"
    namespace = var.namespace
  }

  spec {
    limit {
      type = "Pod"

      # If a Pod/Container doesn't specify resources, these will be applied
      default = {
        cpu    = var.cpu
        memory = var.memory
      }

      default_request = {
        cpu    = var.cpu
        memory = var.memory
      }
    }
  }
}
