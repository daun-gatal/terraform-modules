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

resource "helm_release" "gravitino" {
  name      = var.release_name
  namespace = var.namespace
  chart     = local.chart_path

  values = [
    yamlencode(local.default_values),
    yamlencode(var.values)
  ]
}
