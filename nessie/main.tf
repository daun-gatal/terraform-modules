locals {
  prefix = var.prefix
  release_name = "${local.prefix}-release"
  secret_name = "${local.prefix}-secret"
  s3_secret_name = "${local.prefix}-s3-secret"
  s3_warehouse_location = "s3://${var.nessie_s3_bucket}/${var.nessie_default_warehouse}"
}

resource "kubernetes_namespace" "nessie" {
  metadata {
    name = var.namespace
  }
}

# Apply resource limits to the Nessie namespace
module "nessie_resources" {
  count = var.enable_resource_allocation ? 1 : 0
  source = "../resource"
  
  namespace = kubernetes_namespace.nessie.metadata[0].name
  cpu       = var.cpu_allocation
  memory    = var.memory_allocation
}

resource "kubernetes_secret" "nessie_jdbc" {
  metadata {
    name      = local.secret_name
    namespace = kubernetes_namespace.nessie.metadata[0].name
  }

  data = {
    username = var.nessie_jdbc_username
    password = var.nessie_jdbc_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "nessie_s3" {
  metadata {
    name      = local.s3_secret_name
    namespace = kubernetes_namespace.nessie.metadata[0].name
  }

  data = {
    id = var.nessie_s3_access_key_name
    secret = var.nessie_s3_access_key_secret
  }

  type = "Opaque"
}

resource "helm_release" "nessie" {
  name       = local.release_name
  namespace  = kubernetes_namespace.nessie.metadata[0].name
  repository = "https://charts.projectnessie.org"
  chart      = var.chart_name
  version    = var.chart_version

  values = [<<EOF
  service:
    annotations:
      tailscale.com/expose: "${var.tailscale_expose}"
      tailscale.com/hostname: "${local.prefix}-int"
  EOF
  ]

  set = [
    {
      name  = "versionStoreType"
      value = "JDBC"
    },
    {
        name = "catalog.enabled"
        value = "true"
    },
    {
        name = "catalog.iceberg.defaultWarehouse"
        value = var.nessie_default_warehouse
    },
    {
        name = "catalog.iceberg.warehouses[0].name"
        value = var.nessie_default_warehouse
    },
    {
        name = "catalog.iceberg.warehouses[0].location"
        value = local.s3_warehouse_location
    },
    {
        name = "catalog.storage.s3.defaultOptions.region"
        value = var.nessie_s3_region
    },
    {
        name = "catalog.storage.s3.defaultOptions.endpoint"
        value = var.nessie_s3_endpoint
    },
    {
        name = "catalog.storage.s3.defaultOptions.pathStyleAccess"
        value = "true"
    },
    {
        name = "catalog.storage.s3.defaultOptions.accessKeySecret.name"
        value = local.s3_secret_name
    },
    {
        name = "metrics.enabled"
        value = "false"
    },
    {
        name = "serviceMonitor.enabled"
        value = "false"
    },
    {
        name = "fullnameOverride"
        value = "${local.release_name}"
    }
  ]

  set_sensitive = [
    {
        name = "jdbc.jdbcUrl"
        value = "jdbc:postgresql://${var.nessie_jdbc_url}:${var.nessie_jdbc_port}/${var.nessie_database_name}?currentSchema=public"
    },
    {
        name = "jdbc.secret.name"
        value = local.secret_name
    },
    {
        name = "jdbc.secret.username"
        value = "username"
    },
    {
        name = "jdbc.secret.password"
        value = "password"
    },
    {
        name = "catalog.storage.s3.defaultOptions.accessKeySecret.awsAccessKeyId"
        value = "id"
    },
    {
        name = "catalog.storage.s3.defaultOptions.accessKeySecret.awsSecretAccessKey"
        value = "secret"
    }
  ]
}