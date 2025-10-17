locals {
  spark_conn = "${var.prefix}-spark-conn"
  spark_conn_stateful = "${local.spark_conn}-statefulset"
  spark_conn_svc = "${local.spark_conn}-service"
  spark_image = "${var.image_repository}:${var.image_tag}"
  spark_cluster = "${var.prefix}-spark-cluster"
  spark_cluster_custom_svc = "${local.spark_cluster}-custom-service"
  spark_cluster_ingress = "${local.spark_cluster}-ingress"

  spark_v4 = split(".", var.image_tag)[0] >= 4 ? true : false
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
  count = var.create_spark_cluster ? 1 : 0

  manifest = {
    apiVersion = "spark.apache.org/${var.spark_k8s_opt_version}"
    kind       = "SparkCluster"
    metadata = {
      name      = local.spark_cluster
      namespace = var.namespace
    }
    spec = {
      runtimeVersions = {
        sparkVersion = var.image_tag
      }
      clusterTolerations = {
        instanceConfig = {
          initWorkers = var.cluster_worker_count
          minWorkers  = 1
          maxWorkers  = var.cluster_worker_count
        }
      }
      masterSpec = {
        statefulSetSpec = {
          template = {
            spec = {
              containers = [
                {
                  name = "master"
                  resources = {
                    requests = {
                      cpu = var.master_cpu
                      memory = var.master_memory
                    }
                    limits = {
                      cpu = var.master_cpu
                      memory = var.master_memory
                    }
                  }
                }
              ]
            }
          }
        }
      }
      workerSpec = {
        statefulSetSpec = {
          template = {
            spec = {
              containers = [
                {
                  name = "worker"
                  resources = {
                    requests = {
                      cpu = var.worker_cpu
                      memory = var.worker_memory
                    }
                    limits = {
                      cpu = var.worker_cpu
                      memory = var.worker_memory
                    }
                  }
                }
              ]
            }
          }
        }
      }
      sparkConf = merge(
        {
          "spark.kubernetes.container.image" = local.spark_image
          "spark.master.ui.title"            = var.cluster_name
          "spark.master.rest.enabled"        = "true"
          "spark.master.rest.host"           = "0.0.0.0"
          "spark.ui.reverseProxy"            = "true"
        },
        var.extra_spark_conf
      )
    }
  }
}

resource "kubernetes_manifest" "spark_connect" {
  count = local.spark_v4 ? 1 : 0

  manifest = {
    apiVersion = "spark.apache.org/${var.spark_k8s_opt_version}"
    kind       = "SparkApplication"
    metadata = {
      name      = local.spark_conn_stateful
      namespace = var.namespace
    }
    spec = {
      mainClass = "org.apache.spark.sql.connect.service.SparkConnectServer"
      runtimeVersions = {
        sparkVersion = var.image_tag
      }

      sparkConf = merge(
        {
          "spark.kubernetes.container.image"                         = local.spark_image
          "spark.cores.max"                                      = tostring(var.spark_connect_executor_cores)
          
          "spark.executor.memory"                                    = var.spark_connect_executor_memory
          "spark.executor.instances"                                = tostring(var.spark_connect_dynamic_allocation_min_executors)

          "spark.kubernetes.authenticate.driver.serviceAccountName"  = "spark"
          "spark.ui.reverseProxy"                                    = "true"
          "spark.submit.deployMode"                                  = "cluster"

          "spark.dynamicAllocation.enabled"                           = tostring(var.spark_connect_dynamic_allocation_enabled)
          "spark.dynamicAllocation.shuffleTracking.enabled"            = tostring(var.spark_connect_dynamic_allocation_shuffle_tracking_enabled)
          "spark.dynamicAllocation.minExecutors"                        = tostring(var.spark_connect_dynamic_allocation_min_executors)
          "spark.dynamicAllocation.maxExecutors"                        = tostring(var.spark_connect_dynamic_allocation_max_executors)
        },
        var.create_spark_cluster ? {
          "spark.master" = "spark://${local.spark_cluster}-master-svc:7077"
        } : {},
        var.extra_spark_conf
      )
    }
  }
}


resource "kubernetes_service" "spark_connect" {
  count = local.spark_v4 ? 1 : 0

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
    selector = {
      "spark.operator/spark-app-name" = local.spark_conn_stateful
      "spark-role" = "driver"
    }

    port {
      name        = "connect"
      port        = 15002
      target_port = 15002
      protocol = "TCP"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "spark_custom_service" {
  count = var.create_spark_cluster ? 1 : 0

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

    port {
      name = "spark-master"
      port = 7077
      target_port = 7077
    }

    type = "ClusterIP"
  }
}