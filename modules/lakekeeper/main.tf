locals {
  release_name = "${var.prefix}-release"
  secret_name  = "${var.prefix}-secret"

  # Default values
  default_values = {
    # Fullname override
    fullnameOverride = local.release_name

    catalog = {
      config   = var.catalog_config
      replicas = var.catalog_replicas
    }

    externalDatabase = {
      type              = var.database_type
      host_read         = var.database_host_read
      host_write        = var.database_host_write
      port              = var.database_port
      database          = var.database_name
      user              = var.database_user
      passwordSecret    = local.secret_name
      passwordSecretKey = "postgresql-password"
    }

    service = {
      annotations = {
        "tailscale.com/expose"   = tostring(var.tailscale_expose)
        "tailscale.com/hostname" = "${var.prefix}-web-int"
      }
    }
  }
}

resource "kubernetes_secret_v1" "lakekeeper_secret" {
  metadata {
    name      = local.secret_name
    namespace = var.namespace
  }

  data = {
    "postgresql-password" = var.database_password
  }

  type = "Opaque"
}

resource "helm_release" "lakekeeper" {
  name       = local.release_name
  namespace  = var.namespace
  repository = var.chart_repository
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    yamlencode(local.default_values),
    yamlencode(var.values)
  ]

  depends_on = [kubernetes_secret_v1.lakekeeper_secret]

  recreate_pods = true
  force_update  = true
  wait          = true
  timeout       = 600
}

resource "kubernetes_ingress_v1" "lakekeeper_ingress" {
  count = var.tailscale_funnel ? 1 : 0

  metadata {
    name      = "${local.release_name}-ingress"
    namespace = var.namespace
    annotations = {
      "tailscale.com/funnel" = "true"
    }
  }

  spec {
    ingress_class_name = "tailscale"

    tls {
      hosts = ["${var.prefix}-web-ext"]
    }

    rule {
      host = "${var.prefix}-web-ext"
      http {
        path {
          path      = "/ui"
          path_type = "Prefix"
          backend {
            service {
              name = local.release_name
              port {
                number = 8181
              }
            }
          }
        }
      }
    }
  }
}
