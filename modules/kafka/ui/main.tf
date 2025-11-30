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
            name  = "KAFKA_CLUSTERS_0_NAME"
            value = var.kafka_cluster_name
          }

          env {
            name  = "KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS"
            value = join(",", var.kafka_bootstrap_servers)
          }

          env {
            name = "KAFKA_CLUSTERS_0_SCHEMAREGISTRY"
            value = var.kafka_schema_registry_url
          }

          env {
            name  = "KAFKA_CLUSTERS_0_KAFKACONNECT_0_NAME"
            value = var.kafka_connect_cluster_name
          }

          env {
            name  = "KAFKA_CLUSTERS_0_KAFKACONNECT_0_ADDRESS"
            value = var.kafka_connect_url
          }

          env {
            name  = "KAFKA_CLUSTERS_0_KSQLDBSERVER"
            value = var.kafka_ksqldb_url
          }

          env_from {
            secret_ref {
              name = var.kafka_ui_secret_name
            }
          }

          env {
            name  = "MANAGEMENT_HEALTH_LDAP_ENABLED"
            value = "FALSE"
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
        }
      }
    }
  }
}

resource "kubernetes_service" "kafka_ui" {
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