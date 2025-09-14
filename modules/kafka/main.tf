locals {
  prefix = var.prefix
  
  # Kafka UI
  kafka_ui_deployment_name = "${local.prefix}-ui-deployment"
  kafka_ui_service_name = "${local.prefix}-ui-service"
  kafka_ui_app_label = "${local.prefix}-ui-app"
  kafka_ui_image = "${var.kafka_ui_image}:${var.kafka_ui_image_tag}"
  kafka_ui_secret_name = "${local.prefix}-ui-auth-secret"
}

module "kafka_resources" {
  count = var.enable_resource_allocation ? 1 : 0
  source = "../resource"
  
  namespace = var.namespace
  cpu       = var.cpu_allocation
  memory    = var.memory_allocation
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

        template = {
          bootstrapService = {
            metadata = {
              annotations = {
                "tailscale.com/expose"   = tostring(var.tailscale_expose)
                "tailscale.com/hostname" = "${local.prefix}-bootstrap-int"
              }
            }
          }
        }
      }
      entityOperator = {
        topicOperator = {}
        userOperator  = {}
      }
    }
  }
}

# Kafka UI Resources
resource "kubernetes_secret" "kafka_ui_auth" {
  count = var.enable_kafka_ui && var.kafka_ui_auth_enabled ? 1 : 0

  metadata {
    name      = local.kafka_ui_secret_name
    namespace = var.namespace
  }

  data = {
    username = var.kafka_ui_auth_username
    password = var.kafka_ui_auth_password
  }

  type = "Opaque"
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
            name  = "KAFKA_CLUSTERS_0_NAME"
            value = "${local.prefix}"
          }

          env {
            name  = "KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS"
            value = "${local.prefix}-kafka-bootstrap.${var.namespace}.svc.cluster.local:9092"
          }

          env {
            name  = "KAFKA_CLUSTERS_0_PROPERTIES_SECURITY_PROTOCOL"
            value = "PLAINTEXT"
          }

          env {
            name  = "KAFKA_CLUSTERS_0_ZOOKEEPER"
            value = ""
          }

          env {
            name  = "DYNAMIC_CONFIG_ENABLED"
            value = "true"
          }

          env {
            name  = "SERVER_SERVLET_CONTEXT_PATH"
            value = "/"
          }

          env {
            name  = "AUTH_TYPE"
            value = var.kafka_ui_auth_enabled ? "LOGIN_FORM" : "DISABLED"
          }

          dynamic "env" {
            for_each = var.kafka_ui_auth_enabled ? [1] : []
            content {
              name = "SPRING_SECURITY_USER_NAME"
              value_from {
                secret_key_ref {
                  name = local.kafka_ui_secret_name
                  key  = "username"
                }
              }
            }
          }

          dynamic "env" {
            for_each = var.kafka_ui_auth_enabled ? [1] : []
            content {
              name = "SPRING_SECURITY_USER_PASSWORD"
              value_from {
                secret_key_ref {
                  name = local.kafka_ui_secret_name
                  key  = "password"
                }
              }
            }
          }

          env {
            name  = "MANAGEMENT_HEALTH_LDAP_ENABLED"
            value = "FALSE"
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
      port        = var.kafka_ui_port
      target_port = var.kafka_ui_port
    }

    type = "ClusterIP"
  }
}