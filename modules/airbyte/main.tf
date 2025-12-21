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

}


# Helm Release
resource "helm_release" "airbyte" {
  name       = local.release_name
  namespace  = var.namespace
  repository = var.chart_repository
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    yamlencode(local.default_values),
    yamlencode(var.values)
  ]

  recreate_pods = true
  force_update  = true
  wait          = true
  timeout       = 600
}
