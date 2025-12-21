locals {
  prefix       = var.prefix
  release_name = "${local.prefix}-release"

  # Render catalog configurations from template
  rendered_catalogs = {
    for catalog in var.enabled_catalogs :
    catalog.name => templatefile("${path.module}/templates/catalog.tpl", {
      params = catalog.params
    })
  }

  # Build additional config properties list with shared secret as first item
  additional_config_properties_list = concat(
    ["internal-communication.shared-secret=${var.trino_shared_secret}"],
    var.additional_config_properties
  )

  # Default values - structured like rustfs pattern
  default_values = {
    # Fullname override
    fullnameOverride = local.release_name

    # Image configuration
    image = {
      repository = var.image_repository
      tag        = var.image_tag
    }

    # Service configuration
    service = {
      annotations = {
        "tailscale.com/expose"   = tostring(var.tailscale_expose)
        "tailscale.com/hostname" = "${var.prefix}-int"
      }
    }

    # Server configuration
    server = {
      workers = var.worker_count
    }

    # Coordinator configuration
    coordinator = merge(
      {
        jvm = {
          maxHeapSize = var.trino_coordinator_jvm_max_heap_size
        }
        config = {
          query = {
            maxMemoryPerNode = var.trino_coordinator_query_max_memory
          }
          nodeScheduler = {
            includeCoordinator = var.coordinator_as_worker
          }
        }
      },
      lookup(var.trino_resources_config, "coordinator", null) != null ? {
        resources = {
          requests = {
            cpu    = try(var.trino_resources_config["coordinator"].requests.cpu, null)
            memory = try(var.trino_resources_config["coordinator"].requests.memory, null)
          }
          limits = {
            cpu    = try(var.trino_resources_config["coordinator"].limits.cpu, null)
            memory = try(var.trino_resources_config["coordinator"].limits.memory, null)
          }
        }
      } : {}
    )

    # Worker configuration
    worker = merge(
      {
        jvm = {
          maxHeapSize = var.trino_worker_jvm_max_heap_size
        }
        config = {
          query = {
            maxMemoryPerNode = var.trino_worker_query_max_memory
          }
        }
      },
      lookup(var.trino_resources_config, "worker", null) != null ? {
        resources = {
          requests = {
            cpu    = try(var.trino_resources_config["worker"].requests.cpu, null)
            memory = try(var.trino_resources_config["worker"].requests.memory, null)
          }
          limits = {
            cpu    = try(var.trino_resources_config["worker"].limits.cpu, null)
            memory = try(var.trino_resources_config["worker"].limits.memory, null)
          }
        }
      } : {}
    )

    # Persistence configuration
    persistence = {
      enabled = true
    }

    # Catalogs configuration
    catalogs = local.rendered_catalogs

    # Additional config properties
    additionalConfigProperties = local.additional_config_properties_list

    # Access control configuration
    accessControl = {
      type          = "configmap"
      refreshPeriod = "60s"
      configFile    = "rules.json"
      rules = {
        "rules.json" = jsonencode({
          catalogs = [
            {
              user    = "admin"
              catalog = ".*"
              allow   = "read-only"
            }
          ]
          schemas = [
            {
              user    = "admin"
              catalog = ".*"
              schema  = ".*"
              owner   = false
            }
          ]
          tables = [
            {
              user       = "admin"
              catalog    = ".*"
              schema     = ".*"
              table      = ".*"
              privileges = ["SELECT"]
            }
          ]
        })
      }
    }
  }

}

resource "helm_release" "trino" {
  name       = local.release_name
  namespace  = var.namespace
  repository = "https://trinodb.github.io/charts"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    yamlencode(local.default_values),
    yamlencode(var.values)
  ]

  recreate_pods = true
  force_update  = true
  wait          = true
  timeout       = 600
}

data "kubernetes_config_map" "trino_acl" {
  metadata {
    name      = "${local.release_name}-access-control-volume-coordinator"
    namespace = var.namespace
  }

  depends_on = [helm_release.trino]
}
