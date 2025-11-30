resource "kubernetes_deployment" "kafka_connect" {
  metadata {
    name      = var.kafka_connect_name
    namespace = var.namespace
    labels = {
      app = var.kafka_connect_name
    }
  }

  spec {
    replicas = var.kafka_connect_replicas

    selector {
      match_labels = {
        app = var.kafka_connect_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.kafka_connect_name
        }
      }

      spec {
        container {
          name  = "kafka-connect"
          image = var.kafka_connect_image
          image_pull_policy = "Always"

          port {
            container_port = 8083
          }

          resources {
            limits = {
              cpu = var.kafka_connect_resources_config.limits.cpu
              memory = var.kafka_connect_resources_config.limits.memory
            }
            requests = {
              cpu = var.kafka_connect_resources_config.requests.cpu
              memory = var.kafka_connect_resources_config.requests.memory
            }
          }

          env {
            name  = "CONNECT_BOOTSTRAP_SERVERS"
            value = join(",", var.kafka_bootstrap_servers)
          }

          env {
            name  = "CONNECT_GROUP_ID"
            value = "compose-connect-group"
          }

          env {
            name  = "CONNECT_CONFIG_STORAGE_TOPIC"
            value = "_connect_configs"
          }

          env {
            name  = "CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR"
            value = "1"
          }

          env {
            name  = "CONNECT_OFFSET_STORAGE_TOPIC"
            value = "_connect_offset"
          }

          env {
            name  = "CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR"
            value = "1"
          }

          env {
            name  = "CONNECT_STATUS_STORAGE_TOPIC"
            value = "_connect_status"
          }

          env {
            name  = "CONNECT_STATUS_STORAGE_REPLICATION_FACTOR"
            value = "1"
          }

          env {
            name  = "CONNECT_KEY_CONVERTER"
            value = "org.apache.kafka.connect.storage.StringConverter"
          }

          env {
            name  = "CONNECT_KEY_CONVERTER_SCHEMA_REGISTRY_URL"
            value = var.schema_registry_url
          }

          env {
            name  = "CONNECT_VALUE_CONVERTER"
            value = "org.apache.kafka.connect.storage.StringConverter"
          }

          env {
            name  = "CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL"
            value = var.schema_registry_url
          }

          env {
            name  = "CONNECT_INTERNAL_KEY_CONVERTER"
            value = "org.apache.kafka.connect.json.JsonConverter"
          }

          env {
            name  = "CONNECT_INTERNAL_VALUE_CONVERTER"
            value = "org.apache.kafka.connect.json.JsonConverter"
          }

          env {
            name  = "CONNECT_REST_ADVERTISED_HOST_NAME"
            value = "${var.kafka_connect_name}"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "kafka_connect" {
  metadata {
    name      = "${var.kafka_connect_name}-service"
    namespace = var.namespace
    annotations = {
      "tailscale.com/expose"   = "${var.tailscale_expose}"
      "tailscale.com/hostname" = "${var.kafka_connect_name}-int"
    }
    labels = {
      app = var.kafka_connect_name
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = var.kafka_connect_name
    }

    port {
      name        = "http"
      port        = 8083
      target_port = kubernetes_deployment.kafka_connect.spec[0].template[0].spec[0].container[0].port[0].container_port
    }
  }
}