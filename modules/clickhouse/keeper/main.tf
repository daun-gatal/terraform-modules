resource "kubernetes_service" "keeper" {
  metadata {
    name      = var.cluster_name
    namespace = var.namespace
    labels = {
      app = var.cluster_name
    }
  }

  spec {
    cluster_ip = "None"
    port {
      port = 2181
      name = "client"
    }
    port {
      port = 9444
      name = "raft"
    }
    selector = {
      app = var.cluster_name
    }
  }
}

resource "kubernetes_stateful_set" "keeper" {
  metadata {
    name      = var.cluster_name
    namespace = var.namespace
    labels = {
      app = var.cluster_name
    }
  }

  spec {
    service_name = kubernetes_service.keeper.metadata[0].name
    replicas     = var.replicas

    selector {
      match_labels = {
        app = var.cluster_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.cluster_name
        }
      }

      spec {
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  app = var.cluster_name
                }
              }
              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        container {
          name  = "keeper"
          image = "${var.image_repository}:${var.image_tag}"

          resources {
            requests = {
              memory = var.resources.requests.memory
              cpu    = var.resources.requests.cpu
            }
            limits = {
              memory = var.resources.limits.memory
              cpu    = var.resources.limits.cpu
            }
          }

          port {
            container_port = 2181
            name           = "client"
          }
          port {
            container_port = 9444
            name           = "raft"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/lib/clickhouse-keeper"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }
      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = var.storage_class
        resources {
          requests = {
            storage = var.pvc_size
          }
        }
      }
    }
  }
}
