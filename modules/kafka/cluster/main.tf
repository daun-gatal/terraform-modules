resource "kubernetes_manifest" "kafka_cluster" {
  manifest = {
    apiVersion = "kafka.strimzi.io/v1beta2"
    kind       = "Kafka"
    metadata = {
      name      = var.kafka_cluster_name
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
      }
    }
  }
}