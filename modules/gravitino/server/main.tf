# Auto-download Gravitino charts
data "external" "fetch_charts" {
  program = ["bash", "${path.module}/../scripts/fetch-charts.sh", var.gravitino_version]
}

locals {
  charts_path = data.external.fetch_charts.result.charts_path
  chart_path  = "${local.charts_path}/gravitino"

  # Default values
  default_values = {
    image = {
      tag = var.image_tag
    }

    replicas = var.replicas

    # MySQL configuration
    mysql = {
      enabled = var.mysql_enabled
    }

    # PostgreSQL configuration
    postgresql = {
      enabled = var.postgresql_enabled
    }

    # Entity store JDBC configuration (if provided)
    entity = var.entity_jdbc_config != null ? {
      store        = "relational"
      jdbcUrl      = var.entity_jdbc_config.url
      jdbcDriver   = var.entity_jdbc_config.driver
      jdbcUser     = var.entity_jdbc_config.user
      jdbcPassword = var.entity_jdbc_config.password
    } : {}

    # Resources
    resources = var.resources

    # Service configuration
    service = {
      type        = var.service_type
      annotations = var.service_annotations
    }
  }

  # Merge default values with user-provided values
  merged_values = merge(local.default_values, var.values)
}

resource "helm_release" "gravitino" {
  name      = var.release_name
  namespace = var.namespace
  chart     = local.chart_path

  values = [
    yamlencode(local.merged_values)
  ]
}
