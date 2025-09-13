locals {
  prefix = var.prefix
  release_name = "${local.prefix}-release"

  rendered_catalogs = {
    for catalog in var.enabled_catalogs :
    "catalogs.${catalog.name}" =>
    templatefile("${path.module}/templates/catalog.tpl", {
      params = catalog.params
    })
  }
}

# Apply resource limits to the Trino namespace
module "trino_resources" {
  count = var.enable_resource_allocation ? 1 : 0
  source = "../resource"
  
  namespace = var.namespace
  cpu       = var.cpu_allocation
  memory    = var.memory_allocation
}

resource "helm_release" "trino" {
  name       = local.release_name
  namespace  = var.namespace
  repository = "https://trinodb.github.io/charts"
  chart      = var.chart_name
  version    = var.chart_version

  values = [<<EOF
  service:
    annotations:
      tailscale.com/expose: "${var.tailscale_expose}"
      tailscale.com/hostname: "${var.prefix}-int"
  EOF
  ]

  set = [
    {
        name = "server.workers"
        value = var.worker_count
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
        name = "fullnameOverride"
        value = "${local.release_name}"
    }
  ]

  set_sensitive = concat(
    [
      for name, value in local.rendered_catalogs : {
        name  = name
        value = value
      }
    ],
    [
      {
        name  = "additionalConfigProperties[0]"
        value = "internal-communication.shared-secret=${var.trino_shared_secret}"
      }
    ]
  )
}
