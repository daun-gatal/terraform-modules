############################################
# Kafka Connect Deployment (multi-instance)
############################################
resource "kubernetes_deployment" "kafka_connect" {
  for_each = var.kafka_connect_instances

  metadata {
    name      = each.value.kafka_connect_name
    namespace = var.namespace
    labels = {
      app = each.value.kafka_connect_name
    }
  }

  spec {
    replicas = each.value.replicas

    selector {
      match_labels = {
        app = each.value.kafka_connect_name
      }
    }

    template {
      metadata {
        labels = {
          app = each.value.kafka_connect_name
        }
      }

      spec {
        container {
          name  = "kafka-connect"
          image = each.value.image
          image_pull_policy = "Always"

          port {
            container_port = 8083
          }

          resources {
            limits = {
              cpu    = each.value.resources.limits.cpu
              memory = each.value.resources.limits.memory
            }
            requests = {
              cpu    = each.value.resources.requests.cpu
              memory = each.value.resources.requests.memory
            }
          }

          ###############################
          # Environment Variables
          ###############################

          env {
            name  = "CONNECT_BOOTSTRAP_SERVERS"
            value = join(",", each.value.kafka_bootstrap_servers)
          }

          env {
            name  = "CONNECT_GROUP_ID"
            value = "compose-${each.key}-group"
          }

          env {
            name  = "CONNECT_CONFIG_STORAGE_TOPIC"
            value = "_${each.key}_configs"
          }

          env {
            name  = "CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR"
            value = tostring(each.value.connect_config_storage_replication_factor)
          }

          env {
            name  = "CONNECT_OFFSET_STORAGE_TOPIC"
            value = "_${each.key}_offset"
          }

          env {
            name  = "CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR"
            value = tostring(each.value.connect_offset_storage_replication_factor)
          }

          env {
            name  = "CONNECT_STATUS_STORAGE_TOPIC"
            value = "_${each.key}_status"
          }

          env {
            name  = "CONNECT_STATUS_STORAGE_REPLICATION_FACTOR"
            value = tostring(each.value.connect_status_storage_replication_factor)
          }

          # Converters
          env {
            name  = "CONNECT_KEY_CONVERTER"
            value = "org.apache.kafka.connect.storage.StringConverter"
          }
          env {
            name  = "CONNECT_KEY_CONVERTER_SCHEMA_REGISTRY_URL"
            value = each.value.schema_registry_url
          }

          env {
            name  = "CONNECT_VALUE_CONVERTER"
            value = "org.apache.kafka.connect.storage.StringConverter"
          }
          env {
            name  = "CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL"
            value = each.value.schema_registry_url
          }

          # Internal
          env {
            name  = "CONNECT_INTERNAL_KEY_CONVERTER"
            value = "org.apache.kafka.connect.json.JsonConverter"
          }
          env {
            name  = "CONNECT_INTERNAL_VALUE_CONVERTER"
            value = "org.apache.kafka.connect.json.JsonConverter"
          }

          # REST Host
          env {
            name  = "CONNECT_REST_ADVERTISED_HOST_NAME"
            value = each.value.kafka_connect_name
          }
        }
      }
    }
  }
}

############################################
# Kafka Connect Service (multi-instance)
############################################
resource "kubernetes_service" "kafka_connect" {
  for_each = var.kafka_connect_instances

  metadata {
    name      = "${each.value.kafka_connect_name}-service"
    namespace = var.namespace
    labels = {
      app = each.value.kafka_connect_name
    }

    annotations = {
      "tailscale.com/expose"   = tostring(each.value.tailscale_expose)
      "tailscale.com/hostname" = "${each.value.kafka_connect_name}-int"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = each.value.kafka_connect_name
    }

    port {
      name        = "http"
      port        = 8083
      target_port = 8083
    }
  }
}
