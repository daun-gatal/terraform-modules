locals {
  prefix                = var.prefix
  release_name          = "${local.prefix}-release"
  secret_name           = "${local.prefix}-secret"
  s3_secret_name        = "${local.prefix}-s3-secret"
  s3_warehouse_location = "s3://${var.nessie_s3_bucket}/${var.nessie_default_warehouse}"

  # Default values - structured like rustfs pattern
  default_values = {
    # Fullname override
    fullnameOverride = local.release_name

    # Version store type
    versionStoreType = "JDBC2"

    # Service configuration
    service = {
      annotations = {
        "tailscale.com/expose"   = tostring(var.tailscale_expose)
        "tailscale.com/hostname" = "${local.prefix}-int"
      }
    }

    # Resources configuration
    resources = {
      requests = {
        cpu    = var.nessie_resources_config.requests.cpu
        memory = var.nessie_resources_config.requests.memory
      }
      limits = {
        cpu    = var.nessie_resources_config.limits.cpu
        memory = var.nessie_resources_config.limits.memory
      }
    }

    # JDBC configuration
    jdbc = {
      jdbcUrl = "jdbc:postgresql://${var.nessie_jdbc_url}:${var.nessie_jdbc_port}/${var.nessie_database_name}?currentSchema=public"
      secret = {
        name     = local.secret_name
        username = "username"
        password = "password"
      }
    }

    # Catalog configuration
    catalog = {
      enabled = true
      iceberg = {
        defaultWarehouse = var.nessie_default_warehouse
        warehouses = [
          {
            name     = var.nessie_default_warehouse
            location = local.s3_warehouse_location
          }
        ]
      }
      storage = {
        s3 = {
          defaultOptions = {
            region          = var.nessie_s3_region
            endpoint        = var.nessie_s3_endpoint
            pathStyleAccess = true
            accessKeySecret = {
              name               = local.s3_secret_name
              awsAccessKeyId     = "id"
              awsSecretAccessKey = "secret"
            }
          }
        }
      }
    }

    # Metrics configuration
    metrics = {
      enabled = false
    }

    # Service monitor configuration
    serviceMonitor = {
      enabled = false
    }
  }

  # Merge default values with user-provided values
  merged_values = merge(local.default_values, var.values)
}

# -------------------------------
# Kubernetes Secrets
# -------------------------------
resource "kubernetes_secret" "nessie_jdbc" {
  metadata {
    name      = local.secret_name
    namespace = var.namespace
  }

  data = {
    username = var.nessie_jdbc_username
    password = var.nessie_jdbc_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "nessie_s3" {
  metadata {
    name      = local.s3_secret_name
    namespace = var.namespace
  }

  data = {
    id     = var.nessie_s3_access_key_name
    secret = var.nessie_s3_access_key_secret
  }

  type = "Opaque"
}

# -------------------------------
# Helm Release
# -------------------------------
resource "helm_release" "nessie" {
  name       = local.release_name
  namespace  = var.namespace
  repository = "https://charts.projectnessie.org"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    yamlencode(local.merged_values)
  ]

  depends_on = [
    kubernetes_secret.nessie_jdbc,
    kubernetes_secret.nessie_s3
  ]
}
