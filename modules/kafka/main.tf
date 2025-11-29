locals {
  prefix = var.prefix
  
  # Kafka UI
  kafka_ui_deployment_name = "${local.prefix}-ui-deployment"
  kafka_ui_service_name = "${local.prefix}-ui-service"
  kafka_ui_app_label = "${local.prefix}-ui-app"
  kafka_ui_image = "${var.kafka_ui_image}:${var.kafka_ui_image_tag}"
}

resource "kubernetes_manifest" "kafka_node_pool" {
  manifest = {
    apiVersion = "kafka.strimzi.io/v1beta2"
    kind       = "KafkaNodePool"
    metadata = {
      name      = "node-pool"
      namespace = var.namespace
      labels = {
        "strimzi.io/cluster" = local.prefix
      }
    }
    spec = {
      replicas = var.kafka_replicas
      roles    = var.kafka_roles
      storage = {
        type = "jbod"
        volumes = [
          {
            id            = 0
            type          = var.storage_type
            size          = var.storage_size
            class         = var.storage_class
            deleteClaim   = var.storage_delete_claim
            kraftMetadata = "shared"
          }
        ]
      }
      template = {
        pod = {
          securityContext = {
            runAsUser  = var.pod_run_as_user
            runAsGroup = var.pod_run_as_group
            fsGroup    = var.pod_fs_group
          }
        }
      }
      resources = {
        requests = {
          cpu    = var.kafka_resources_config.requests.cpu
          memory = var.kafka_resources_config.requests.memory
        }
        limits = {
          cpu    = var.kafka_resources_config.limits.cpu
          memory = var.kafka_resources_config.limits.memory
        }
      }
    }
  }
}

resource "kubernetes_manifest" "kafka_cluster" {
  manifest = {
    apiVersion = "kafka.strimzi.io/v1beta2"
    kind       = "Kafka"
    metadata = {
      name      = local.prefix
      namespace = var.namespace
      annotations = {
        "strimzi.io/node-pools" = "enabled"
        "strimzi.io/kraft"      = "enabled"
      }
    }
    spec = {
      kafka = {
        version         = var.kafka_version
        metadataVersion = var.kafka_metadata_version
        listeners = [
          {
            name = "plain"
            port = var.kafka_port
            type = var.kafka_listener_type
            tls  = var.kafka_tls_enabled
          }
        ]
        config = {
          "offsets.topic.replication.factor"         = var.offsets_topic_replication_factor
          "transaction.state.log.replication.factor" = var.transaction_state_log_replication_factor
          "transaction.state.log.min.isr"            = var.transaction_state_log_min_isr
          "default.replication.factor"               = var.default_replication_factor
          "min.insync.replicas"                      = var.min_insync_replicas
        }
      }
    }
  }
}

resource "kubernetes_deployment" "schema_registry" {
  count = var.enable_schema_registry ? 1 : 0
  depends_on = [ kubernetes_manifest.kafka_cluster ]

  metadata {
    name      = "${var.prefix}-schema-registry"
    namespace = var.namespace
    labels = {
      app = "${var.prefix}-schema-registry"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "${var.prefix}-schema-registry"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.prefix}-schema-registry"
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
            value = "PLAINTEXT://${local.prefix}-kafka-bootstrap.${var.namespace}.svc.cluster.local:9092"
          }

          env {
            name  = "SCHEMA_REGISTRY_HOST_NAME"
            value = "${var.prefix}-schema-registry"
          }

          env {
            name  = "SCHEMA_REGISTRY_KAFKASTORE_TOPIC"
            value = "_schemas"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "schema_registry" {
  metadata {
    name      = "${var.prefix}-schema-registry-service"
    namespace = var.namespace
    annotations = {
      "tailscale.com/expose"   = "false"
      "tailscale.com/hostname" = "${local.prefix}-schema-registry-int"
    }
    labels = {
      app = "${var.prefix}-schema-registry"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = "${var.prefix}-schema-registry"
    }

    port {
      name        = "http"
      port        = 8081
      target_port = 8081
    }
  }
}

resource "kubernetes_stateful_set" "ksqldb" {
  count = var.enable_ksqldb ? 1 : 0
  depends_on = [ kubernetes_deployment.schema_registry ]

  metadata {
    name      = "${var.prefix}-ksqldb-server"
    namespace = var.namespace
    labels = {
      app = "${var.prefix}-ksqldb-server"
    }
  }

  spec {
    service_name = "${var.prefix}-ksqldb-headless"
    replicas     = 1

    selector {
      match_labels = {
        app = "${var.prefix}-ksqldb-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.prefix}-ksqldb-server"
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
          name  = "${var.prefix}-ksqldb-server"
          image = "confluentinc/cp-ksqldb-server:${var.ksqldb_version}"

          env {
            name  = "KSQL_CONFIG_DIR"
            value = "/etc/ksql"
          }
          env {
            name  = "KSQL_BOOTSTRAP_SERVERS"
            value = "PLAINTEXT://${local.prefix}-kafka-bootstrap.${var.namespace}.svc.cluster.local:9092"
          }
          env {
            name  = "KSQL_HOST_NAME"
            value = "${var.prefix}-ksqldb-server"
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
            value = "http://${kubernetes_service.schema_registry.metadata[0].name}.${var.namespace}.svc.cluster.local:8081"
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
        storage_class_name = var.storage_class

        resources {
          requests = {
            storage = var.ksqldb_storage_size
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ksqldb" {
  metadata {
    name      =  "${var.prefix}-ksqldb-service"
    namespace = var.namespace

    annotations = {
      "tailscale.com/expose"   = "false"
      "tailscale.com/hostname" = "ksqldb-int"
    }
  }

  spec {
    selector = {
      app = "${var.prefix}-ksqldb-server"
    }

    port {
      port        = 8088
      target_port = 8088
      protocol    = "TCP"
    }
  }
}


resource "kubernetes_deployment" "kafka_ui" {
  count = var.enable_kafka_ui ? 1 : 0

  metadata {
    name      = local.kafka_ui_deployment_name
    namespace = var.namespace
    labels = {
      app = local.kafka_ui_app_label
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = local.kafka_ui_app_label
      }
    }

    template {
      metadata {
        labels = {
          app = local.kafka_ui_app_label
        }
      }
      spec {
        container {
          name  = "kafka-ui"
          image = local.kafka_ui_image

          port {
            container_port = var.kafka_ui_port
            name           = "http"
          }

          env {
            name  = "KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS"
            value = "${local.prefix}-kafka-bootstrap.${var.namespace}.svc.cluster.local:${var.kafka_port}"
          }

          env {
            name = "KAFKA_CLUSTERS_0_SCHEMAREGISTRY"
            value = var.enable_schema_registry ? "${kubernetes_service.schema_registry.metadata[0].name}.${var.namespace}.svc.cluster.local:8081" : ""
          }

          env {
            name  = "KAFKA_CLUSTERS_0_KSQLDBSERVER"
            value = var.enable_ksqldb ? "${kubernetes_service.ksqldb.metadata[0].name}.${var.namespace}.svc.cluster.local:8088" : ""
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
              port = var.kafka_ui_port
            }
            initial_delay_seconds = 60
            period_seconds        = 30
            timeout_seconds       = 10
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/actuator/health"
              port = var.kafka_ui_port
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
  count = var.enable_kafka_ui ? 1 : 0

  metadata {
    name      = local.kafka_ui_service_name
    namespace = var.namespace
    labels = {
      app = local.kafka_ui_app_label
    }
    annotations = {
      "tailscale.com/expose"   = "${var.kafka_ui_tailscale_expose}"
      "tailscale.com/hostname" = "${local.prefix}-ui-int"
    }
  }

  spec {
    selector = {
      app = local.kafka_ui_app_label
    }

    port {
      name        = "http"
      port        = 80
      target_port = var.kafka_ui_port
    }

    type = "ClusterIP"
  }
}