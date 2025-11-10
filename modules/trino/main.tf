locals {
  prefix = var.prefix
  release_name = "${local.prefix}-release"

  coordinator_resources_requests_cpu = var.trino_resources_config["coordinator"].requests.cpu
  coordinator_resources_requests_ram = var.trino_resources_config["coordinator"].requests.ram
  coordinator_resources_limits_cpu   = var.trino_resources_config["coordinator"].limits.cpu
  coordinator_resources_limits_ram   = var.trino_resources_config["coordinator"].limits.ram

  worker_resources_requests_cpu = var.trino_resources_config["worker"].requests.cpu
  worker_resources_requests_ram = var.trino_resources_config["worker"].requests.ram
  worker_resources_limits_cpu   = var.trino_resources_config["worker"].limits.cpu
  worker_resources_limits_ram   = var.trino_resources_config["worker"].limits.ram

  rendered_catalogs = {
    for catalog in var.enabled_catalogs :
    "catalogs.${catalog.name}" =>
    templatefile("${path.module}/templates/catalog.tpl", {
      params = catalog.params
    })
  }

  existing_acl = try(
    jsondecode(lookup(data.kubernetes_config_map.trino_acl.data, "rules.json", "{}")),
    {}
  )
  trino_acl_config_rendered = jsonencode(merge(
    local.existing_acl,
    {
      for key, value in var.trino_acl_config :
      key => concat(lookup(local.existing_acl, key, []), value)
    }
  ))
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
  coordinator:
    resources:
      requests:
        cpu: "${local.coordinator_resources_requests_cpu}"
        memory: "${local.coordinator_resources_requests_ram}"
      limits:
        cpu: "${local.coordinator_resources_limits_cpu}"
        memory: "${local.coordinator_resources_limits_ram}"
  worker:
    resources:
      requests:
        cpu: "${local.worker_resources_requests_cpu}"
        memory: "${local.worker_resources_requests_ram}"
      limits:
        cpu: "${local.worker_resources_limits_cpu}"
        memory: "${local.worker_resources_limits_ram}"
  accessControl:
    type: configmap
    refreshPeriod: 60s
    configFile: "rules.json"
    rules:
      rules.json: ${jsonencode(local.trino_acl_config_rendered)}
  EOF
  ]

  set = [
    {
        name = "image.repository"
        value = var.image_repository
    },
    {
        name = "image.tag"
        value = var.image_tag
    },
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
    ],
    [
      for idx, property in var.additional_config_properties : {
        name  = "additionalConfigProperties[${idx + 1}]"
        value = property
      }
    ]
  )
}

data "kubernetes_config_map" "trino_acl" {
  metadata {
    name      = "${local.release_name}-access-control-volume-coordinator"
    namespace = var.namespace
  }

  depends_on = [ helm_release.trino ]
}
