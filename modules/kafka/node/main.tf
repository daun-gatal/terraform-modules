

resource "kubernetes_manifest" "kafka_node_pool" {
  manifest = {
    apiVersion = "kafka.strimzi.io/v1beta2"
    kind       = "KafkaNodePool"
    metadata = {
      name      = var.kafka_node_pool_name
      namespace = var.namespace
      labels = {
        "strimzi.io/cluster" = var.kafka_cluster_name
      }
    }
    spec = merge(
      {
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
      },
      var.kafka_node_resources_config != null ? {
        resources = {
          requests = {
            cpu    = try(var.kafka_node_resources_config.requests.cpu, null)
            memory = try(var.kafka_node_resources_config.requests.memory, null)
          }
          limits = {
            cpu    = try(var.kafka_node_resources_config.limits.cpu, null)
            memory = try(var.kafka_node_resources_config.limits.memory, null)
          }
        }
      } : {}
    )
  }
}