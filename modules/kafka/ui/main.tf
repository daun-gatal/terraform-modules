resource "kubernetes_deployment" "kafka_ui" {
  metadata {
    name      = var.kafka_ui_name
    namespace = var.namespace
    labels = {
      app = var.kafka_ui_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.kafka_ui_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.kafka_ui_name
        }
      }
      spec {
        container {
          name  = "kafka-ui"
          image = "ghcr.io/kafbat/kafka-ui:${var.kafka_ui_version}"

          port {
            container_port = 8080
            name           = "http"
          }

          env {
            name  = "MANAGEMENT_HEALTH_LDAP_ENABLED"
            value = "FALSE"
          }

          env {
            name = "SPRING_CONFIG_ADDITIONAL-LOCATION"
            value = "/tmp/config.yml"
          }

          resources {
            limits = {
              cpu = var.kafka_ui_resources_config.limits.cpu
              memory = var.kafka_ui_resources_config.limits.memory
            }
            requests = {
              cpu = var.kafka_ui_resources_config.requests.cpu
              memory = var.kafka_ui_resources_config.requests.memory
            }
          }

          liveness_probe {
            http_get {
              path = "/actuator/health"
              port = 8080
            }
            initial_delay_seconds = 60
            period_seconds        = 30
            timeout_seconds       = 10
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/actuator/health"
              port = 8080
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          volume_mount {
            name       = "kafka-ui-config"
            mount_path = "/tmp/config.yml"
            sub_path   = "config.yml"
            read_only  = true
          }
        }
        
        volume {
          name = "kafka-ui-config"
          secret {
            secret_name = var.kafka_ui_secret_name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "kafka_ui" {
  depends_on = [kubernetes_deployment.kafka_ui]

  metadata {
    name      = "${var.kafka_ui_name}-service"
    namespace = var.namespace
    labels = {
      app = var.kafka_ui_name
    }
    annotations = {
      "tailscale.com/expose"   = "${var.tailscale_expose}"
      "tailscale.com/hostname" = "${var.kafka_ui_name}-int"
    }
  }

  spec {
    selector = {
      app = var.kafka_ui_name
    }

    port {
      name        = "http"
      port        = 80
      target_port = kubernetes_deployment.kafka_ui.spec[0].template[0].spec[0].container[0].port[0].container_port
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "superset_ingress" {
  count = var.tailscale_funnel ? 1 : 0

  depends_on = [kubernetes_service.kafka_ui]

  metadata {
    name      = "${kubernetes_service.kafka_ui.metadata[0].name}-funnel"
    namespace = var.namespace

    annotations = {
      "tailscale.com/funnel" = "true"
    }
  }

  spec {
    ingress_class_name = "tailscale"

    tls {
      hosts = [
        "${var.kafka_ui_name}-ext"
      ]
    }

    rule {
      host = "${var.kafka_ui_name}-ext"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.kafka_ui.metadata[0].name

              port {
                number = kubernetes_service.kafka_ui.spec[0].port[0].port
              }
            }
          }
        }
      }
    }
  }
}
