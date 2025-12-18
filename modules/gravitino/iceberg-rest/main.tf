# Auto-download Gravitino charts
data "external" "fetch_charts" {
  program = ["bash", "${path.module}/../scripts/fetch-charts.sh", var.gravitino_version]
}

locals {
  charts_path = data.external.fetch_charts.result.charts_path
  chart_path  = "${local.charts_path}/gravitino-iceberg-rest-server"

  # Default values
  default_values = {
    image = {
      tag = var.image_tag
    }

    replicas = var.replicas

    # Iceberg REST configuration
    icebergRest = merge(
      {
        catalogBackend = var.catalog_backend
        warehouse      = var.warehouse
      },
      # JDBC config (if provided)
      var.jdbc_config != null ? {
        jdbc = {
          user       = var.jdbc_config.user
          password   = var.jdbc_config.password
          driver     = var.jdbc_config.driver
          initialize = var.jdbc_config.initialize
        }
      } : {},
      # S3 config (if provided)
      var.s3_config != null ? {
        s3 = {
          accessKeyId     = var.s3_config.access_key_id
          secretAccessKey = var.s3_config.secret_access_key
          endpoint        = var.s3_config.endpoint
          region          = var.s3_config.region
          pathStyleAccess = var.s3_config.path_style_access
        }
      } : {},
      # IO implementation (if provided)
      var.io_impl != null ? {
        ioImpl = var.io_impl
      } : {}
    )

    # Resources (only if configured)
    resources = var.resources != null ? {
      requests = var.resources.requests != null ? {
        cpu    = try(var.resources.requests.cpu, null)
        memory = try(var.resources.requests.memory, null)
      } : {}
      limits = var.resources.limits != null ? {
        cpu    = try(var.resources.limits.cpu, null)
        memory = try(var.resources.limits.memory, null)
      } : {}
    } : {}

    # Service configuration
    service = {
      type        = var.service_type
      annotations = var.service_annotations
    }
  }

}

resource "helm_release" "iceberg_rest" {
  name      = var.release_name
  namespace = var.namespace
  chart     = local.chart_path

  values = [
    yamlencode(local.default_values),
    yamlencode(var.values)
  ]
}
