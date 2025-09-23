locals {
  prefix = var.prefix
  app_label = "${local.prefix}-app"
  cluster_name = "${local.prefix}-cluster"
  postgres_image = "${var.image_repository}:${var.image_tag}"
}

# Apply resource limits to the Postgres namespace
module "postgres_resources" {
  count = var.enable_resource_allocation ? 1 : 0
  source = "../resource"
  
  namespace = var.namespace
  cpu       = var.cpu_allocation
  memory    = var.memory_allocation
}

resource "kubernetes_manifest" "postgres_cluster" {
  manifest = {
    apiVersion = "postgresql.cnpg.io/v1"
    kind       = "Cluster"
    
    metadata = {
      name      = local.cluster_name
      namespace = var.namespace
      labels = {
        app = local.app_label
      }
    }
    
    spec = {
      imageName = local.postgres_image
      instances = var.postgres_replicas

      # Database initialization
      bootstrap = {
        initdb = {
          database = var.db_name
          owner    = var.db_user
          secret = {
            name = kubernetes_secret.postgres_credentials.metadata[0].name
          }
        }
      }

      # Storage configuration
      storage = {
        size         = var.storage_size
        storageClass = var.storage_class_name
      }
    }
  }
}

# Secret for PostgreSQL credentials
resource "kubernetes_secret" "postgres_credentials" {
  metadata {
    name      = "${local.prefix}-credentials"
    namespace = var.namespace
  }

  data = {
    username = var.db_user
    password = var.db_password
  }

  type = "kubernetes.io/basic-auth"
}

resource "kubernetes_manifest" "extra_postgres_databases" {
  for_each = toset(var.extra_db_names)

  manifest = {
    apiVersion = "postgresql.cnpg.io/v1"
    kind       = "Database"

    metadata = {
      name      = each.value
    }

    spec = {
      name    = each.value
      owner   = var.db_user
      cluster = {
        name = local.cluster_name
      }
    }
  }

  depends_on = [
    kubernetes_manifest.postgres_cluster,
    kubernetes_secret.postgres_credentials
  ]
}

# Apply custom PostgreSQL parameters after cluster creation
resource "null_resource" "postgres_config" {
  depends_on = [
    kubernetes_manifest.postgres_cluster, 
    kubernetes_secret.postgres_credentials, 
    kubernetes_manifest.extra_postgres_databases
  ]

  triggers = {
    parameters = jsonencode(var.postgresql_parameters)
    cluster_name = local.cluster_name
    namespace = var.namespace
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Wait for cluster to be ready
      kubectl wait --for=condition=Ready cluster/${local.cluster_name} -n ${var.namespace} --timeout=300s
      
      # Apply custom PostgreSQL parameters if any are specified
      if [ "${length(var.postgresql_parameters)}" -gt 0 ]; then
        echo "Applying custom PostgreSQL parameters..."
        kubectl patch cluster ${local.cluster_name} -n ${var.namespace} --type='merge' -p='
        {
          "spec": {
            "postgresql": {
              "parameters": ${jsonencode(var.postgresql_parameters)}
            }
          }
        }'
        echo "Custom PostgreSQL parameters applied successfully"
      fi
    EOT
  }
}