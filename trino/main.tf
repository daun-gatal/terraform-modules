terraform {
  required_providers {
    htpasswd = {
      source  = "loafoe/htpasswd"
      version = "1.2.1"
    }
  }
}

locals {
  prefix = var.prefix
  release_name = "${local.prefix}-release"
  coordinator_name = "${local.prefix}-coordinator"
  worker_name = "${local.prefix}-worker"
}

resource "kubernetes_namespace" "trino" {
  metadata {
    name = var.namespace
  }
}

resource "htpasswd_password" "trino" {
  password = var.trino_admin_password
}

resource "helm_release" "trino" {
  name       = local.release_name
  namespace  = kubernetes_namespace.trino.metadata[0].name
  repository = "https://trinodb.github.io/charts"
  chart      = var.chart_name
  version    = var.chart_version

  values = [<<EOF
  service:
    annotations:
      tailscale.com/expose: "${var.tailscale_expose}"
  EOF
  ]

  set = [
    {
        name  = "nameOverride"
        value = local.release_name
    },
    {
        name = "coordinatorNameOverride"
        value = local.coordinator_name
    },
    {
        name = "workerNameOverride"
        value = local.worker_name
    },
    {
        name = "server.workers"
        value = var.worker_count
    },
    {
        name = "server.config.authenticationType"
        value = "PASSWORD"
    },
    {
        name = "coordinator.jvm.maxHeapSize"
        value = var.trino_coordinator_jvm_max_heap_size
    },
    {
        name = "coordinator.config.query.maxMemoryPerNode"
        value = var.trino_coordinator_query_max_memory
    },
    {
        name = "worker.jvm.maxHeapSize"
        value = var.trino_worker_jvm_max_heap_size
    },
    {
        name = "worker.config.query.maxMemoryPerNode"
        value = var.trino_worker_query_max_memory
    },
    {
        name = "persistence.enabled"
        value = "true"
    },
    {
        name = "coordinator.config.nodeScheduler.includeCoordinator"
        value = var.coordinator_as_worker 
    },
    {
        name = "server.config.https.enabled"
        value = var.enable_https
    }
  ]

  set_sensitive = [
    {
        name = "catalogs.iceberg"
        value = <<EOF
        connector.name=iceberg
        iceberg.catalog.type=${var.iceberg_catalog_type}
        iceberg.nessie-catalog.uri=${var.iceberg_nessie_uri}
        iceberg.nessie-catalog.ref=${var.iceberg_nessie_ref}
        iceberg.nessie-catalog.default-warehouse-dir=${var.iceberg_nessie_default_warehouse}
        fs.native-s3.enabled=${var.nessie_native_s3_enabled}
        s3.endpoint=${var.nessie_s3_endpoint}
        s3.region=${var.nessie_s3_region}
        s3.aws-access-key=${var.nessie_s3_access_key}
        s3.aws-secret-key=${var.nessie_s3_secret_key}
        s3.path-style-access=${var.nessie_s3_path_style_access}
        EOF
    },
    {
        name = "auth.passwordAuth"
        value = "${var.trino_admin_user}:${htpasswd_password.trino.bcrypt}"
    },
    {
      name  = "additionalConfigProperties[0]"
      value = "internal-communication.shared-secret=${var.trino_shared_secret}"
    }
  ]
}
