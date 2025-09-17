locals {
  prefix       = var.prefix
  release_name = "${local.prefix}-release"
}

# Apply resource limits to the Gravitino namespace
module "gravitino_resources" {
  count  = var.enable_resource_allocation ? 1 : 0
  source = "../resource"

  namespace = var.namespace
  cpu       = var.cpu_allocation
  memory    = var.memory_allocation
}

resource "helm_release" "gravitino" {
  name       = local.release_name
  namespace  = var.namespace
  repository = "https://datastrato.github.io/multicloud-deployment/"
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
      name  = "entity.store"
      value = var.entity_store
    },
    {
      name  = "entity.jdbcUrl"
      value = var.entity_jdbc_url
    },
    {
      name  = "entity.jdbcDriver"
      value = var.entity_jdbc_driver
    },
    {
      name  = "entity.jdbcUser"
      value = var.entity_jdbc_user
    },
    {
      name  = "entity.storagePath"
      value = var.entity_storage_path
    },
    {
      name  = "auxService.names"
      value = var.aux_service_names
    },
    {
      name  = "icebergRest.catalogBackend"
      value = var.iceberg_rest_catalog_backend
    },
    {
      name  = "icebergRest.warehouse"
      value = var.iceberg_rest_warehouse
    },
    {
      name  = "icebergRest.jdbc.user"
      value = var.iceberg_rest_jdbc_user
    },
    {
      name  = "icebergRest.jdbc.driver"
      value = var.iceberg_rest_jdbc_driver
    },
    {
      name  = "icebergRest.jdbc.initialize"
      value = var.iceberg_rest_jdbc_initialize
    },
    {
      name  = "icebergRest.ioImpl"
      value = var.iceberg_rest_io_impl
    },
    {
      name  = "icebergRest.credentialProviders"
      value = var.iceberg_rest_credential_providers
    },
    {
      name  = "icebergRest.s3.endpoint"
      value = var.iceberg_rest_s3_endpoint
    },
    {
      name  = "icebergRest.s3.region"
      value = var.iceberg_rest_s3_region
    },
    {
      name  = "icebergRest.s3.pathStyleAccess"
      value = var.iceberg_rest_s3_path_style_access
    },
    {
      name  = "replicas"
      value = var.replicas
    },
    {
      name  = "persistence.enabled"
      value = var.persistence_enabled
    },
    {
      name  = "persistence.size"
      value = var.persistence_size
    },
    {
      name  = "persistence.storageClassName"
      value = var.persistence_storage_class
    },
    {
      name  = "env[0].name"
      value = "GRAVITINO_HOME"
    },
    {
      name  = "env[0].value"
      value = var.gravitino_home
    },
    {
      name  = "env[1].name"
      value = "GRAVITINO_MEM"
    },
    {
      name  = "env[1].value"
      value = var.gravitino_mem
    },
    {
      name  = "fullnameOverride"
      value = "${local.release_name}"
    }
  ]

  set_sensitive = [
    {
      name  = "entity.jdbcPassword"
      value = var.entity_jdbc_password
    },
    {
      name  = "icebergRest.jdbc.password"
      value = var.iceberg_rest_jdbc_password
    },
    {
      name  = "icebergRest.s3.accessKeyId"
      value = var.iceberg_rest_s3_access_key_id
    },
    {
      name  = "icebergRest.s3.secretAccessKey"
      value = var.iceberg_rest_s3_secret_access_key
    }
  ]
}
