locals {
  namespace = var.namespace
  labels = {
    app = "dockge"
  }
}

resource "kubernetes_service" "headless" {
  metadata {
    name      = "dockge-headless"
    namespace = local.namespace
    labels    = local.labels
  }
  spec {
    cluster_ip = "None"
    selector   = local.labels
    port {
      name        = "http"
      port        = var.container_port
      target_port = var.container_port
    }
  }
}

resource "kubernetes_service" "dockge" {
  metadata {
    name      = "dockge"
    namespace = local.namespace
    labels    = local.labels
    annotations = {
      "tailscale.com/expose"   = tostring(var.tailscale_expose)
      "tailscale.com/hostname" = var.tailscale_hostname
    }
  }
  spec {
    type     = var.service_type
    selector = local.labels
    port {
      name        = "http"
      port        = var.service_port
      target_port = var.container_port
    }
  }
}

resource "kubernetes_stateful_set" "dockge" {
  metadata {
    name      = "dockge"
    namespace = local.namespace
    labels    = local.labels
  }

  spec {
    service_name = kubernetes_service.headless.metadata[0].name
    replicas     = 1

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }

      spec {
        container {
          name  = "dockge"
          image = var.dockge_image

          port {
            container_port = var.container_port
          }

          env {
            name  = "DOCKER_HOST"
            value = "tcp://localhost:2375"
          }

          dynamic "env" {
            for_each = var.dockge_env
            content {
              name  = env.value.name
              value = env.value.value
            }
          }

          resources {
            requests = try(var.resources.dockge.requests, null)
            limits   = try(var.resources.dockge.limits, null)
          }

          volume_mount {
            name       = "dockge-data"
            mount_path = "/app/data"
          }
        }

        container {
          name  = "dind"
          image = var.dind_image

          security_context {
            privileged = true
          }

          env {
            name  = "DOCKER_TLS_CERTDIR"
            value = ""
          }

          dynamic "env" {
            for_each = var.dind_env
            content {
              name  = env.value.name
              value = env.value.value
            }
          }

          resources {
            requests = try(var.resources.dind.requests, null)
            limits   = try(var.resources.dind.limits, null)
          }

          volume_mount {
            name       = "dind-storage"
            mount_path = "/var/lib/docker"
          }

          volume_mount {
            name       = "dockge-data"
            mount_path = "/app/data"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "dockge-data"
      }
      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = var.storage_class_name
        resources {
          requests = {
            storage = var.dockge_data_size
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "dind-storage"
      }
      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = var.storage_class_name
        resources {
          requests = {
            storage = var.dind_storage_size
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "dockge_ingress" {
  count = var.tailscale_funnel ? 1 : 0

  metadata {
    name      = "dockge-ingress"
    namespace = local.namespace
    annotations = {
      "tailscale.com/funnel" = "true"
    }
  }

  spec {
    ingress_class_name = "tailscale"

    tls {
      hosts = [var.ingress_host]
    }

    rule {
      host = var.ingress_host
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.dockge.metadata[0].name
              port {
                number = var.service_port
              }
            }
          }
        }
      }
    }
  }
}
