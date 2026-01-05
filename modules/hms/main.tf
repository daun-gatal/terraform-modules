locals {
  name_metastore = "${var.prefix}-metastore"

  default_hive_config = {
    "javax.jdo.option.ConnectionURL"      = "jdbc:postgresql://${var.database_host}:${var.database_port}/${var.database_name}"
    "javax.jdo.option.ConnectionUserName" = var.database_user
    "javax.jdo.option.ConnectionPassword" = var.database_password
    "fs.s3a.access.key"                   = var.s3_access_key
    "fs.s3a.secret.key"                   = var.s3_secret_key
    "fs.s3a.endpoint"                     = var.s3_endpoint
    "hive.metastore.warehouse.dir"        = var.hive_metastore_warehouse_dir
  }
}

resource "kubernetes_config_map" "hms_config" {
  metadata {
    name      = "${var.prefix}-config"
    namespace = var.namespace
  }

  data = {
    "hive-site.xml" = templatefile("${path.module}/templates/hive-site.xml.tpl", {
      config = merge(local.default_hive_config, var.hive_site_config)
    })
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
            value = "/opt/hive/lib/ext/*:/opt/hive/lib/*"
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
            mount_path = "/opt/hive/lib/ext"
          }

          volume_mount {
            name       = "hive-config"
            mount_path = "/opt/hive/conf/hive-site.xml"
            sub_path   = "hive-site.xml"
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
        volume {
          name = "hive-config"
          config_map {
            name = kubernetes_config_map.hms_config.metadata[0].name
          }
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
