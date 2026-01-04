locals {
  name_metastore = "${var.prefix}-metastore"

  # Construct SERVICE_OPTS for PostgreSQL connection
  # S3 configuration can also be added here if needed
  postgres_opts = join(" ", [
    "-Djavax.jdo.option.ConnectionDriverName=org.postgresql.Driver",
    "-Djavax.jdo.option.ConnectionURL=jdbc:postgresql://${var.database_host}:${var.database_port}/${var.database_name}",
    "-Djavax.jdo.option.ConnectionUserName=${var.database_user}",
    "-Djavax.jdo.option.ConnectionPassword=${var.database_password}",
    "-Ddatanucleus.schema.autoCreateAll=true" # Ensure schema is created
  ])

  s3_opts = var.s3_endpoint != "" ? join(" ", [
    "-Dfs.s3a.access.key=${var.s3_access_key}",
    "-Dfs.s3a.secret.key=${var.s3_secret_key}",
    "-Dfs.s3a.endpoint=${var.s3_endpoint}",
    "-Dfs.s3a.path.style.access=true",
    "-Dhive.metastore.warehouse.dir=${var.hive_metastore_warehouse_dir}",
    "-Dhive.warehouse.subdir.inherit.perms=true",
    "-Dhive.metastore.pre.event.listeners=org.apache.hadoop.hive.ql.security.authorization.AuthorizationPreEventListener",
    "-Dhive.security.metastore.authorization.manager=org.apache.hadoop.hive.ql.security.authorization.StorageBasedAuthorizationProvider",
    "-Dfs.s3a.aws.credentials.provider=org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider"
  ]) : ""

  service_opts = "${local.postgres_opts} ${local.s3_opts}"
}

resource "kubernetes_secret" "hms_config" {
  metadata {
    name      = "${var.prefix}-config"
    namespace = var.namespace
  }

  data = {
    "SERVICE_OPTS" = local.service_opts
  }
}

# ============================================
# Hive Metastore Deployment
# ============================================

resource "kubernetes_deployment" "metastore" {

  metadata {
    name      = local.name_metastore
    namespace = var.namespace
    labels = {
      app       = local.name_metastore
      component = "metastore"
    }
  }

  spec {
    replicas = var.metastore_replicas

    selector {
      match_labels = {
        app       = local.name_metastore
        component = "metastore"
      }
    }

    template {
      metadata {
        labels = {
          app       = local.name_metastore
          component = "metastore"
        }
      }

      spec {
        init_container {
          name              = "download-driver"
          image             = "curlimages/curl:8.5.0"
          image_pull_policy = "IfNotPresent"
          command           = ["/bin/sh", "-c"]
          args = [
            join("; ", [for filename, url in var.additional_jars : "if [ ! -f /driver-libs/${filename} ]; then echo 'Downloading ${filename}...'; curl -L -o /driver-libs/${filename} \"${url}\"; else echo '${filename} already exists'; fi"])
          ]

          volume_mount {
            name       = "driver-libs"
            mount_path = "/driver-libs"
          }
        }

        container {
          name              = "metastore"
          image             = "${var.image_repository}:${var.image_tag}"
          image_pull_policy = var.image_pull_policy

          env {
            name  = "SERVICE_NAME"
            value = "metastore"
          }

          env {
            name  = "DB_DRIVER"
            value = "postgres"
          }

          # Add HADOOP_CLASSPATH to include the driver
          env {
            name  = "HADOOP_CLASSPATH"
            value = "/opt/hive/lib/postgres/*"
          }

          env {
            name = "SERVICE_OPTS"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.hms_config.metadata[0].name
                key  = "SERVICE_OPTS"
              }
            }
          }

          env {
            name  = "AWS_ACCESS_KEY_ID"
            value = var.s3_access_key
          }

          env {
            name  = "AWS_SECRET_ACCESS_KEY"
            value = var.s3_secret_key
          }

          # Add extra env vars
          dynamic "env" {
            for_each = var.extra_env_vars
            content {
              name  = env.key
              value = env.value
            }
          }

          port {
            name           = "metastore"
            container_port = 9083
          }

          volume_mount {
            name       = "driver-libs"
            mount_path = "/opt/hive/lib/postgres"
          }

          resources {
            limits = {
              cpu    = try(var.resources_config.metastore.limits.cpu, null)
              memory = try(var.resources_config.metastore.limits.memory, null)
            }
            requests = {
              cpu    = try(var.resources_config.metastore.requests.cpu, null)
              memory = try(var.resources_config.metastore.requests.memory, null)
            }
          }
        }
        volume {
          name = "driver-libs"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "metastore" {

  metadata {
    name      = local.name_metastore
    namespace = var.namespace
    labels = {
      app       = local.name_metastore
      component = "metastore"
    }
    annotations = {
      "tailscale.com/expose"   = tostring(var.tailscale_expose)
      "tailscale.com/hostname" = "${var.prefix}-metastore-int"
    }
  }

  spec {
    selector = {
      app       = local.name_metastore
      component = "metastore"
    }

    port {
      name        = "metastore"
      port        = 9083
      target_port = 9083
    }

    type = "ClusterIP"
  }
}
