resource "kubernetes_deployment" "schema_registry" {
  metadata {
    name      = var.kafka_schema_registry_name
    namespace = var.namespace
    labels = {
      app = var.kafka_schema_registry_name
    }
  }

  spec {
    replicas = var.kafka_schema_registry_replicas

    selector {
      match_labels = {
        app = var.kafka_schema_registry_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.kafka_schema_registry_name
        }
      }

      spec {
        container {
          name  = "schema-registry"
          image = "confluentinc/cp-schema-registry:${var.schema_registry_version}"

          port {
            container_port = 8081
          }

          resources {
            limits = {
              cpu = var.kafka_schema_registry_resources_config.limits.cpu
              memory = var.kafka_schema_registry_resources_config.limits.memory
            }
            requests = {
              cpu = var.kafka_schema_registry_resources_config.requests.cpu
              memory = var.kafka_schema_registry_resources_config.requests.memory
            }
          }

          env {
            name  = "SCHEMA_REGISTRY_LISTENERS"
            value = "http://0.0.0.0:8081"
          }

          env {
            name  = "SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS"
            value = join(",", var.kafka_bootstrap_servers)
          }

          env {
            name  = "SCHEMA_REGISTRY_HOST_NAME"
            value = var.kafka_schema_registry_name
          }

          env {
            name  = "SCHEMA_REGISTRY_KAFKASTORE_TOPIC"
            value = "_${var.kafka_schema_registry_name}_schemas"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "schema_registry" {
  metadata {
    name      = "${var.kafka_schema_registry_name}-service"
    namespace = var.namespace
    annotations = {
      "tailscale.com/expose"   = "${var.tailscale_expose}"
      "tailscale.com/hostname" = "${var.kafka_schema_registry_name}-int"
    }
    labels = {
      app = var.kafka_schema_registry_name
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = var.kafka_schema_registry_name
    }

    port {
      name        = "http"
      port        = 8081
      target_port = kubernetes_deployment.schema_registry.spec[0].template[0].spec[0].container[0].port[0].container_port
    }
  }
}