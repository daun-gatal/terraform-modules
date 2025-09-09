locals {
  prefix = var.prefix
  deployment_name = "${local.prefix}-deployment"
  app_label = "${local.prefix}-app"
  container_name = "${local.prefix}-container"
  service_name = "${local.prefix}-service"
  metabase_image = "${var.image}:${var.image_tag}"
  ingress_name = "${local.prefix}-ingress"
}

resource "kubernetes_namespace" "metabase" {
  metadata {
    name = var.namespace
  }
}

# Apply resource limits to the Metabase namespace
module "metabase_resources" {
  count = var.enable_resource_allocation ? 1 : 0
  source = "../resource"
  
  namespace = var.namespace
  cpu       = var.cpu_allocation
  memory    = var.memory_allocation
}

resource "kubernetes_deployment" "metabase" {
  metadata {
    name      = local.deployment_name
    namespace = kubernetes_namespace.metabase.metadata[0].name
    labels = {
      app = local.app_label
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = local.app_label
      }
    }
    template {
      metadata {
        labels = {
          app = local.app_label
        }
      }
      spec {
        container {
          name  = local.container_name
          image = local.metabase_image

          env {
            name  = "MB_DB_TYPE"
            value = "postgres"
          }

          env {
            name  = "MB_DB_DBNAME"
            value = var.metabase_db_name
          }

          env {
            name  = "MB_DB_PORT"
            value = "${var.metabase_db_port}"
          }

          env {
            name  = "MB_DB_USER"
            value = var.metabase_db_user
          }

          env {
            name  = "MB_DB_PASS"
            value = var.metabase_db_password
          }

          env {
            name  = "MB_DB_HOST"
            value = var.metabase_db_host
          }

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "metabase" {
  metadata {
    name      = local.service_name
    namespace = var.namespace
    annotations = {
      "tailscale.com/expose" = "${var.tailscale_expose}"
      "tailscale.com/hostname" = "${local.prefix}-int"
    }
  }

  spec {
    selector = {
      app = local.app_label
    }

    port {
      port        = kubernetes_deployment.metabase.spec[0].template[0].spec[0].container[0].port[0].container_port
      target_port = kubernetes_deployment.metabase.spec[0].template[0].spec[0].container[0].port[0].container_port
    }

    type                 = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "metabase" {
  count = var.tailscale_funnel ? 1 : 0

  metadata {
    name = local.ingress_name
    namespace = var.namespace

    annotations = {
      "tailscale.com/funnel" = "${var.tailscale_funnel}"
    }
  }

  spec {
    ingress_class_name = "tailscale"

    default_backend {
      service {
        name = local.service_name

        port {
          number = kubernetes_deployment.metabase.spec[0].template[0].spec[0].container[0].port[0].container_port
        }
      }
    }

    tls {
      hosts = ["${var.prefix}-ext"]
    }
  }
}

