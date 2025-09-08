locals {
  prefix = var.prefix
  service_name = "${local.prefix}-service"
  statefulset_name = "${local.prefix}-statefulset"
  app_label = "${local.prefix}-app"
  kafka_image = "${var.kafka_image}:${var.kafka_image_tag}"
  pv_name = "${local.prefix}-pv"
  
  # Kafka UI
  kafka_ui_deployment_name = "${local.prefix}-ui-deployment"
  kafka_ui_service_name = "${local.prefix}-ui-service"
  kafka_ui_app_label = "${local.prefix}-ui-app"
  kafka_ui_image = "${var.kafka_ui_image}:${var.kafka_ui_image_tag}"
  kafka_ui_secret_name = "${local.prefix}-ui-auth-secret"
  kafka_ui_ingress_name = "${local.prefix}-ui-ingress"
}

resource "kubernetes_namespace" "kafka" {
  metadata {
    name = var.namespace
  }
}

# Single Persistent Volume for Kafka
resource "kubernetes_persistent_volume" "kafka" {
  metadata {
    name = local.pv_name
  }

  spec {
    capacity = {
      storage = var.storage_size
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "standard"

    persistent_volume_source {
      host_path {
        path = "/data/${var.namespace}/${local.prefix}"
        type = "DirectoryOrCreate"
      }
    }
  }
}

resource "kubernetes_service" "kafka" {
  metadata {
    name      = local.service_name
    namespace = kubernetes_namespace.kafka.metadata[0].name
    labels = {
      app = local.app_label
    }
    annotations = {
      "tailscale.com/expose"   = "${var.tailscale_expose}"
      "tailscale.com/hostname" = "${local.prefix}-int"
    }
  }

  spec {
    selector = {
      app = local.app_label
    }

    port {
      name        = "kafka"
      port        = var.kafka_port
      target_port = var.kafka_port
    }

    dynamic "port" {
      for_each = var.enable_jmx ? [1] : []
      content {
        name        = "jmx"
        port        = var.jmx_port
        target_port = var.jmx_port
      }
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_stateful_set" "kafka" {
  metadata {
    name      = local.statefulset_name
    namespace = kubernetes_namespace.kafka.metadata[0].name
    labels = {
      app = local.app_label
    }
  }

  spec {
    service_name = kubernetes_service.kafka.metadata[0].name
    replicas     = 1

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
        # Security context to ensure proper permissions for Kafka user
        security_context {
          fs_group = 1000
          run_as_user = 1000
          run_as_group = 1000
          run_as_non_root = true
        }

        # Init container to fix volume permissions
        init_container {
          name  = "fix-permissions"
          image = "busybox:1.35"
          command = ["sh", "-c"]
          args = [
            "chown -R 1000:1000 /var/lib/kafka/data && chmod -R 755 /var/lib/kafka/data"
          ]
          
          security_context {
            run_as_user = 0  # Run as root to change ownership
          }
          
          volume_mount {
            name       = "kafka-storage"
            mount_path = "/var/lib/kafka/data"
          }
        }

        container {
          name  = "kafka"
          image = local.kafka_image

          port {
            container_port = var.kafka_port
            name           = "kafka"
          }

          port {
            container_port = var.kafka_controller_port
            name           = "controller"
          }

          dynamic "port" {
            for_each = var.enable_jmx ? [1] : []
            content {
              container_port = var.jmx_port
              name           = "jmx"
            }
          }

          command = ["/bin/bash", "-c"]
          args = [
            <<-EOF
            export KAFKA_NODE_ID=0
            export KAFKA_ADVERTISED_LISTENERS="PLAINTEXT://${local.statefulset_name}-0.${local.service_name}.${var.namespace}.svc.cluster.local:${var.kafka_port}"
            exec /etc/confluent/docker/run
            EOF
          ]

          env {
            name  = "KAFKA_PROCESS_ROLES"
            value = "broker,controller"
          }

          env {
            name  = "KAFKA_CONTROLLER_QUORUM_VOTERS"
            value = "0@${local.statefulset_name}-0.${local.service_name}.${var.namespace}.svc.cluster.local:${var.kafka_controller_port}"
          }

          env {
            name  = "KAFKA_LISTENERS"
            value = "PLAINTEXT://:${var.kafka_port},CONTROLLER://:${var.kafka_controller_port}"
          }

          env {
            name  = "KAFKA_LISTENER_SECURITY_PROTOCOL_MAP"
            value = "CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT"
          }

          env {
            name  = "KAFKA_CONTROLLER_LISTENER_NAMES"
            value = "CONTROLLER"
          }

          env {
            name  = "KAFKA_HEAP_OPTS"
            value = "-Xmx${var.kafka_heap_size} -Xms${var.kafka_heap_size}"
          }

          env {
            name  = "KAFKA_LOG_RETENTION_HOURS"
            value = "${var.kafka_log_retention_hours}"
          }

          env {
            name  = "KAFKA_LOG_DIRS"
            value = "/var/lib/kafka/data"
          }

          env {
            name  = "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR"
            value = "1"
          }

          env {
            name  = "KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR"
            value = "1"
          }

          env {
            name  = "KAFKA_TRANSACTION_STATE_LOG_MIN_ISR"
            value = "1"
          }

          env {
            name  = "KAFKA_DEFAULT_REPLICATION_FACTOR"
            value = "1"
          }

          env {
            name  = "KAFKA_MIN_INSYNC_REPLICAS"
            value = "1"
          }

          env {
            name  = "KAFKA_NUM_PARTITIONS"
            value = "${var.kafka_num_partitions}"
          }

          dynamic "env" {
            for_each = var.enable_jmx ? [1] : []
            content {
              name  = "KAFKA_JMX_OPTS"
              value = "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.port=${var.jmx_port} -Dcom.sun.management.jmxremote.rmi.port=${var.jmx_port}"
            }
          }

          volume_mount {
            name       = "kafka-storage"
            mount_path = "/var/lib/kafka/data"
          }

          resources {
            requests = {
              memory = var.memory_request
              cpu    = var.cpu_request
            }
            limits = {
              memory = var.memory_limit
              cpu    = var.cpu_limit
            }
          }

          liveness_probe {
            tcp_socket {
              port = var.kafka_port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            tcp_socket {
              port = var.kafka_port
            }
            initial_delay_seconds = 15
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 3
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "kafka-storage"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = var.storage_size
          }
        }
        storage_class_name = "standard"
      }
    }
  }
}

# Kafka UI Resources
resource "kubernetes_secret" "kafka_ui_auth" {
  count = var.enable_kafka_ui && var.kafka_ui_auth_enabled ? 1 : 0

  metadata {
    name      = local.kafka_ui_secret_name
    namespace = kubernetes_namespace.kafka.metadata[0].name
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
    namespace = kubernetes_namespace.kafka.metadata[0].name
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
            value = "${local.prefix}-cluster"
          }

          env {
            name  = "KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS"
            value = "${local.service_name}.${var.namespace}.svc.cluster.local:${var.kafka_port}"
          }

          env {
            name  = "KAFKA_CLUSTERS_0_PROPERTIES_SECURITY_PROTOCOL"
            value = "PLAINTEXT"
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

          resources {
            requests = {
              memory = "256Mi"
              cpu    = "100m"
            }
            limits = {
              memory = "512Mi"
              cpu    = "500m"
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
    namespace = kubernetes_namespace.kafka.metadata[0].name
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

resource "kubernetes_ingress_v1" "kafka_ui_tailscale_funnel" {
  count = var.enable_kafka_ui && var.kafka_ui_tailscale_funnel ? 1 : 0

  metadata {
    name      = local.kafka_ui_ingress_name
    namespace = var.namespace

    annotations = {
      "tailscale.com/funnel" = "${var.kafka_ui_tailscale_funnel}"
    }
  }

  spec {
    ingress_class_name = "tailscale"

    default_backend {
      service {
        name = local.kafka_ui_service_name

        port {
          number = var.kafka_ui_port
        }
      }
    }

    tls {
      hosts = ["${var.prefix}-ui-ext"]
    }
  }

  depends_on = [kubernetes_deployment.kafka_ui]
}