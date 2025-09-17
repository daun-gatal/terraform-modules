# Create a ResourceQuota for the namespace to limit resource consumption
resource "kubernetes_resource_quota" "namespace_quota" {
  metadata {
    name      = "${var.namespace}-resource-quota"
    namespace = var.namespace
  }

  spec {
    hard = {
      # Total namespace limits only (more flexible)
      "cpu"    = var.cpu
      "memory" = var.memory
    }
  }
}
