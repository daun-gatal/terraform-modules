locals {
  name_metastore = "${var.prefix}-metastore"
}

resource "kubernetes_config_map" "hms_config" {
  metadata {
    name      = "${var.prefix}-config"
    namespace = var.namespace
  }

  data = {
    "hive-site.xml" = <<EOF
<configuration>
  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>org.postgresql.Driver</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:postgresql://${var.database_host}:${var.database_port}/${var.database_name}</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>${var.database_user}</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>${var.database_password}</value>
  </property>
  <property>
    <name>datanucleus.schema.autoCreateAll</name>
    <value>true</value>
  </property>
  <property>
    <name>fs.s3a.access.key</name>
    <value>${var.s3_access_key}</value>
  </property>
  <property>
    <name>fs.s3a.secret.key</name>
    <value>${var.s3_secret_key}</value>
  </property>
  <property>
    <name>fs.s3a.endpoint</name>
    <value>${var.s3_endpoint}</value>
  </property>
  <property>
    <name>fs.s3a.path.style.access</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.metastore.warehouse.dir</name>
    <value>${var.hive_metastore_warehouse_dir}</value>
  </property>
  <property>
    <name>hive.warehouse.subdir.inherit.perms</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.metastore.pre.event.listeners</name>
    <value>org.apache.hadoop.hive.ql.security.authorization.AuthorizationPreEventListener</value>
  </property>
  <property>
    <name>hive.security.metastore.authorization.manager</name>
    <value>org.apache.hadoop.hive.ql.security.authorization.StorageBasedAuthorizationProvider</value>
  </property>
  <property>
    <name>fs.s3a.aws.credentials.provider</name>
    <value>org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider,org.apache.hadoop.fs.s3a.auth.EnvironmentVariableCredentialsProvider</value>
  </property>
  <property>
    <name>fs.s3a.connection.ssl.enabled</name>
    <value>false</value>
  </property>
  <property>
    <name>fs.s3a.impl</name>
    <value>org.apache.hadoop.fs.s3a.S3AFileSystem</value>
  </property>
  <property>
    <name>fs.s3a.endpoint.region</name>
    <value>us-east-1</value>
  </property>
</configuration>
EOF
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
