locals {
  release_name = var.release_name

  # Minimal default values - relies on Helm chart defaults
  default_values = {
    global = {
      edition = "community"
    }

    postgresql = {
      enabled = var.postgresql_enabled
    }

    minio = {
      enabled = var.minio_enabled
    }
  }

  # Merge default values with user-provided values
  merged_values = merge(local.default_values, var.values)
}

# Helm Release
resource "helm_release" "airbyte" {
  name       = local.release_name
  namespace  = var.namespace
  repository = var.chart_repository
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    yamlencode(local.merged_values)
  ]
}
