locals {
  prefix = var.prefix
  deployment_name = "${local.prefix}-deployment"
  app_label = "${local.prefix}-app"
  container_name = "${local.prefix}-container"
  service_name = "${local.prefix}-service"
  postgres_image = "${var.image}:${var.image_tag}"
  pv_name = "${local.prefix}-pv"
  pvc_name = "${local.prefix}-pvc"
  storage_name = "${local.prefix}-storage"
}

resource "kubernetes_namespace" "postgres" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_persistent_volume" "postgres" {
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
        path = "/data/${local.prefix}"  # Adjust path on your machine
        type = "DirectoryOrCreate"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "postgres" {
  metadata {
    name      = local.pvc_name
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "standard"
    resources {
      requests = {
        storage = var.storage_size
      }
    }
    volume_name = kubernetes_persistent_volume.postgres.metadata[0].name
  }
}


resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = local.deployment_name
    namespace = kubernetes_namespace.postgres.metadata[0].name
    labels = {
      app = local.app_label
    }
  }

  spec {
    replicas = 1
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
        container {
          name  = local.container_name
          image = local.postgres_image

          env {
            name  = "POSTGRES_PASSWORD"
            value = var.db_password
          }

          env {
            name  = "POSTGRES_USER"
            value = var.db_user
          }

          env {
            name  = "POSTGRES_DB"
            value = var.db_name
          }

          port {
            container_port = var.db_port
          }

          volume_mount {
            name       = local.storage_name
            mount_path = "/var/lib/postgresql/data"
          }
        }

        volume {
          name = local.storage_name
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name      = local.service_name
    namespace = var.namespace
    annotations = {
      "tailscale.com/expose" = "${var.tailscale_expose}"
    }
  }

  spec {
    selector = {
      app = local.app_label
    }

    port {
      port        = var.db_port
      target_port = var.db_port
    }

    type                 = "ClusterIP"
  }
}
