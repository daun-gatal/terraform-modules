# Admin Password Secret
resource "kubernetes_secret" "clickhouse_credentials" {
  metadata {
    name      = "clickhouse-credentials"
    namespace = var.namespace
  }
  data = {
    "admin-password" = var.admin_password
  }
  type = "Opaque"
}

# ClickHouseInstallation CRD
resource "kubernetes_manifest" "chi" {
  manifest = {
    apiVersion = "clickhouse.altinity.com/v1"
    kind       = "ClickHouseInstallation"
    metadata = {
      name      = var.cluster_name
      namespace = var.namespace
    }
    spec = {
      configuration = {
        zookeeper = {
          nodes = [
            for i in range(var.keeper_replicas) : {
              host = "${split("-", var.keeper_service_name)[0]}-${i}.${var.keeper_service_name}"
              port = 2181
            }
          ]
        }
        clusters = [
          {
            name = "main"
            templates = {
              clusterServiceTemplate = "cluster-service"
            }
            layout = {
              shardsCount   = var.shards_count
              replicasCount = var.replicas_count
            }
          }
        ]
        users = {
          "admin/k8s_secret_password" = "${kubernetes_secret.clickhouse_credentials.metadata[0].name}/admin-password"
          "admin/networks/ip"         = ["0.0.0.0/0"]
          "admin/access_management"   = 1
        }
        settings = {
          max_server_memory_usage_to_ram_ratio = 0.8
        }
      }
      templates = {
        podTemplates = [
          {
            name = "default"
            spec = {
              affinity = {
                podAntiAffinity = {
                  requiredDuringSchedulingIgnoredDuringExecution = [
                    {
                      labelSelector = {
                        matchLabels = {
                          "clickhouse.altinity.com/chi" = var.cluster_name
                        }
                      }
                      topologyKey = "kubernetes.io/hostname"
                    }
                  ]
                }
              }
              containers = [
                {
                  name  = "clickhouse"
                  image = "${var.image_repository}:${var.image_tag}"
                  resources = {
                    requests = {
                      memory = var.resources.requests.memory
                      cpu    = var.resources.requests.cpu
                    }
                    limits = {
                      memory = var.resources.limits.memory
                      cpu    = var.resources.limits.cpu
                    }
                  }
                }
              ]
            }
          }
        ]
        volumeClaimTemplates = [
          {
            name = "data-volume"
            spec = {
              accessModes      = ["ReadWriteOnce"]
              storageClassName = var.storage_class
              resources = {
                requests = {
                  storage = var.pvc_size
                }
              }
            }
          }
        ]
        serviceTemplates = [
          {
            name         = "cluster-service"
            generateName = "clickhouse-{chi}"
            metadata = {
              annotations = var.service_annotations
            }
            spec = {
              type = "ClusterIP"
              ports = [
                {
                  name       = "http"
                  port       = 8123
                  targetPort = 8123
                },
                {
                  name       = "tcp"
                  port       = 9000
                  targetPort = 9000
                }
              ]
            }
          }
        ]
      }
      defaults = {
        templates = {
          podTemplate             = "default"
          dataVolumeClaimTemplate = "data-volume"
        }
      }
    }
  }
}
