resource "kubernetes_deployment" "ui" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          name  = "clickhouse-ui"
          image = "${var.image_repository}:${var.image_tag}"

          env {
            name  = "VITE_CLICKHOUSE_URLS"
            value = var.clickhouse_urls
          }

          port {
            container_port = 5521
          }

          resources {
            requests = {
              memory = var.resources.requests.memory
              cpu    = var.resources.requests.cpu
            }
            limits = {
              memory = var.resources.limits.memory
              cpu    = var.resources.limits.cpu
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ui" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    annotations = {
      "tailscale.com/expose"   = tostring(var.tailscale_expose)
      "tailscale.com/hostname" = "${var.app_name}-int"
    }
  }

  spec {
    type = "ClusterIP"
    port {
      port        = 80
      target_port = 5521
    }
    selector = {
      app = var.app_name
    }
  }
}

resource "kubernetes_ingress_v1" "ui_funnel" {
  count = var.tailscale_funnel ? 1 : 0

  metadata {
    name      = "${var.app_name}-funnel"
    namespace = var.namespace
    annotations = {
      "tailscale.com/funnel" = "true"
    }
  }

  spec {
    ingress_class_name = "tailscale"

    tls {
      hosts = ["${var.app_name}-ext"]
    }

    rule {
      host = "${var.app_name}-ext"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.ui.metadata[0].name
              port {
                number = kubernetes_service.ui.spec[0].port[0].port
              }
            }
          }
        }
      }
    }
  }
}
