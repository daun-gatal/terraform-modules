locals {
  spark_conn = "${var.prefix}-spark-conn"
  spark_conn_stateful = "${local.spark_conn}-statefulset"
  spark_conn_svc = "${local.spark_conn}-service"
  spark_image = "${var.image_repository}:${var.image_tag}"
  spark_cluster = "${var.prefix}-spark-cluster"
  spark_cluster_custom_svc = "${local.spark_cluster}-custom-service"
  spark_cluster_ingress = "${local.spark_cluster}-ingress"
}

# Apply resource limits to the Spark namespace
module "spark_resources" {
  count = var.enable_resource_allocation ? 1 : 0
  source = "../resource"
  
  namespace = var.namespace
  cpu       = var.cpu_allocation
  memory    = var.memory_allocation
}

resource "kubernetes_manifest" "spark_cluster" {
  manifest = {
    apiVersion = "spark.apache.org/${var.spark_k8s_opt_version}"
    kind       = "SparkCluster"
    metadata = {
      name      =local.spark_cluster
      namespace = var.namespace
    }
    spec = {
      runtimeVersions = {
        sparkVersion = var.image_tag
      }
      clusterTolerations = {
        instanceConfig = {
          initWorkers = var.cluster_worker_count
          minWorkers  = var.cluster_worker_count
          maxWorkers  = var.cluster_worker_count
        }
      }
      sparkConf = {
        "spark.kubernetes.container.image" = local.spark_image
        "spark.master.ui.title"            = var.cluster_name
        "spark.master.rest.enabled"        = "true"
        "spark.master.rest.host"           = "0.0.0.0"
        "spark.ui.reverseProxy"            = "true"
      }
    }
  }
}

resource "kubernetes_service" "spark_connect" {
  metadata {
    name      = local.spark_conn_svc
    namespace = var.namespace
    labels = { app = local.spark_conn }
    annotations = {
      "tailscale.com/expose" = "${var.tailscale_expose}"
      "tailscale.com/hostname" = "${var.prefix}-connect-int"
    }
  }

  spec {
    selector = { app = local.spark_conn }

    port {
      name        = "connect"
      port        = 15002
      target_port = 15002
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_stateful_set" "spark_connect" {
  metadata {
    name      = local.spark_conn_stateful
    namespace = var.namespace
  }

  spec {
    service_name = kubernetes_service.spark_connect.metadata[0].name
    replicas     = 1

    selector {
      match_labels = { app = local.spark_conn }
    }

    template {
      metadata {
        labels = { app = local.spark_conn }
      }

      spec {
        container {
          name  = local.spark_conn
          image = "bitnami/spark:${var.image_tag}"

          env {
            name  = "SPARK_MODE"
            value = "driver"
          }

          env {
            name  = "SPARK_MASTER"
            value = "spark://${local.spark_cluster}-master-svc:7077"
          }

          port {
            container_port = 15002
            name           = "connect"
          }

          command = [
            "/bin/bash",
            "-c",
            templatefile("${path.module}/scripts/spark-connect-server.sh", {
              master_url       = "spark://${local.spark_cluster}-master-svc:7077"
              executor_memory  = var.spark_connect_executor_memory
              executor_cores   = var.spark_connect_executor_cores
              max_cores        = var.spark_connect_max_cores
            })
          ]
        }
      }
    }
  }

  depends_on = [ kubernetes_manifest.spark_cluster ]
}

resource "kubernetes_service" "spark_custom_service" {
  count = var.tailscale_expose ? 1 : 0

  metadata {
    name      = local.spark_cluster_custom_svc
    namespace = var.namespace
    labels = { app = local.spark_cluster }
    annotations = {
      "tailscale.com/expose" = "${var.tailscale_expose}"
      "tailscale.com/hostname" = "${var.prefix}-master-int"
    }
  }

  spec {
    selector = { spark-role = "master" }

    port {
      name        = "spark-web"
      port        = 8080
      target_port = 8080
    }

    type = "ClusterIP"
  }
}