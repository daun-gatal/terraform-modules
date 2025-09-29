# Create a LimitRange to set default pod requests/limits in the namespace
resource "kubernetes_limit_range" "namespace_limits" {
  metadata {
    name      = "${var.namespace}-limit-range"
    namespace = var.namespace
  }

  spec {
    limit {
      type = "Pod"

      # Default values applied when pods don't specify resources
      default = {
        cpu    = var.cpu
        memory = var.memory
      }
    }
  }
}

# Create a ResourceQuota for the namespace to limit resource consumption
resource "kubernetes_resource_quota" "namespace_quota" {
  metadata {
    name      = "${var.namespace}-resource-quota"
    namespace = var.namespace
  }

  spec {
    hard = {
      # Namespace-wide hard caps
      "cpu"    = var.cpu
      "memory" = var.memory
    }
  }

  depends_on = [ kubernetes_limit_range.namespace_limits ]
}