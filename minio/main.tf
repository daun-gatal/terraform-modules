locals {
  prefix = var.prefix
  deployment_name = "${local.prefix}-deployment"
  app_label = "${local.prefix}-app"
  container_name = "${local.prefix}-container"
  service_name = "${local.prefix}-service"
  minio_image = "${var.image}:${var.image_tag}"
  pv_name = "${local.prefix}-pv"
  pvc_name = "${local.prefix}-pvc"
  storage_name = "${local.prefix}-storage"
}


resource "kubernetes_namespace" "minio" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_persistent_volume" "minio" {
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
        path = "/data/${local.prefix}"  # folder inside Minikube VM
        type = "DirectoryOrCreate"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "minio" {
  metadata {
    name      = local.pvc_name
    namespace = kubernetes_namespace.minio.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "standard"
    resources {
      requests = {
        storage = var.storage_size
      }
    }
    volume_name = kubernetes_persistent_volume.minio.metadata[0].name
  }
}

resource "kubernetes_deployment" "minio" {
  metadata {
    name      = local.deployment_name
    namespace = kubernetes_namespace.minio.metadata[0].name
    labels = { app = local.app_label }
  }

  spec {
    replicas = 1
    selector {
      match_labels = { app = local.app_label }
    }
    template {
      metadata {
        labels = { app = local.app_label }
      }
      spec {
        container {
          name  = local.container_name
          image = local.minio_image

          env {
            name  = "MINIO_ROOT_USER"
            value = var.minio_root_user
          }

          env {
            name  = "MINIO_ROOT_PASSWORD"
            value = var.minio_root_password
          }

          env {
            name  = "MINIO_DEFAULT_BUCKETS"
            value = var.minio_bucket_name
          }

          env {
            name  = "MINIO_BROWSER"
            value = "on"
          }

          env {
            name  = "MINIO_CONSOLE_PORT_NUMBER"
            value = var.minio_console_port
          }

          env {
            name  = "MINIO_API_PORT_NUMBER"
            value = var.minio_api_port
          }

          port {
            container_port = var.minio_api_port
          }

          port {
            container_port = var.minio_console_port
          }

          volume_mount {
            name       = local.storage_name
            mount_path = "/data"
          }
        }

        volume {
          name = local.storage_name
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.minio.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "minio" {
  metadata {
    name      = local.service_name
    namespace = kubernetes_namespace.minio.metadata[0].name
  }

  spec {
    selector = { app = local.app_label }

    port {
      name       = "api"
      port       = var.minio_api_port
      target_port = var.minio_api_port
    }

    port {
      name       = "console"
      port       = var.minio_console_port
      target_port = var.minio_console_port
    }

    type                 = "LoadBalancer"
    load_balancer_class  = "tailscale"
  }
}
