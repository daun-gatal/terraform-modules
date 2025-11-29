resource "kubernetes_stateful_set" "ksqldb" {
  metadata {
    name      = var.kafka_ksqldb_name
    namespace = var.namespace
    labels = {
      app = var.kafka_ksqldb_name
    }
  }

  spec {
    service_name = "${var.kafka_ksqldb_name}-headless"
    replicas     = 1

    selector {
      match_labels = {
        app = var.kafka_ksqldb_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.kafka_ksqldb_name
        }
      }

      spec {

        init_container {
          name  = "fix-permissions"
          image = "busybox"

          command = ["sh", "-c", "chmod -R 777 /etc/ksql"]

          volume_mount {
            name       = "ksqldb-data"
            mount_path = "/etc/ksql"
          }
        }

        container {
          name  = var.kafka_ksqldb_name
          image = "confluentinc/cp-ksqldb-server:${var.ksqldb_version}"

          env {
            name  = "KSQL_CONFIG_DIR"
            value = "/etc/ksql"
          }
          env {
            name  = "KSQL_BOOTSTRAP_SERVERS"
            value = join(",", var.kafka_bootstrap_servers)
          }
          env {
            name  = "KSQL_HOST_NAME"
            value = var.kafka_ksqldb_name
          }
          env {
            name  = "KSQL_LISTENERS"
            value = "http://0.0.0.0:8088"
          }
          env {
            name  = "KSQL_CACHE_MAX_BYTES_BUFFERING"
            value = "0"
          }
          env {
            name  = "KSQL_KSQL_SCHEMA_REGISTRY_URL"
            value = var.kafka_schema_registry_url
          }
          env {
            name  = "KSQL_KSQL_LOGGING_PROCESSING_TOPIC_REPLICATION_FACTOR"
            value = "1"
          }
          env {
            name  = "KSQL_KSQL_LOGGING_PROCESSING_TOPIC_AUTO_CREATE"
            value = "true"
          }
          env {
            name  = "KSQL_KSQL_LOGGING_PROCESSING_STREAM_AUTO_CREATE"
            value = "true"
          }

          port {
            container_port = 8088
          }

          resources {
            limits = {
              cpu = var.kafka_ksqldb_resources_config.limits.cpu
              memory = var.kafka_ksqldb_resources_config.limits.memory
            }
            requests = {
              cpu = var.kafka_ksqldb_resources_config.requests.cpu
              memory = var.kafka_ksqldb_resources_config.requests.memory
            }
          }

          volume_mount {
            name       = "ksqldb-data"
            mount_path = "/etc/ksql"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "ksqldb-data"
      }

      spec {
        access_modes      = ["ReadWriteOnce"]
        storage_class_name = var.ksqldb_storage_class_name

        resources {
          requests = {
            storage = var.kafka_ksqldb_storage_size
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ksqldb" {
  metadata {
    name      =  "${var.kafka_ksqldb_name}-service"
    namespace = var.namespace

    annotations = {
      "tailscale.com/expose"   = "${var.tailscale_expose}"
      "tailscale.com/hostname" = "${var.kafka_ksqldb_name}-int"
    }
  }

  spec {
    selector = {
      app = var.kafka_ksqldb_name
    }

    port {
      port        = 8088
      target_port = kubernetes_stateful_set.ksqldb.spec[0].template[0].spec[0].container[0].port[0].container_port
      protocol    = "TCP"
    }
  }
}