locals {
  prefix = var.prefix
  release_name = "${local.prefix}-release"
  secret_name = "${local.prefix}-secret"
  conn_secret_name = "${local.prefix}-conn-secret"
  migrate_job_name = "${local.prefix}-migrate-job"
}

resource "kubernetes_namespace" "airflow" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "airflow_secret" {
  metadata {
    name      = local.secret_name
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }

  data = {
    connection       = "postgresql://${var.airflow_db_user}:${var.airflow_db_password}@${var.airflow_db_host}:${var.airflow_db_port}/${var.airflow_db_name}"
    fernet-key       = var.airflow_fernet_key
    api-secret-key   = var.airflow_api_secret_key
    gitSshKey        = file("${var.git_ssh_key_path}")
  }

  type = "Opaque"
}

resource "kubernetes_secret" "airflow_conn_secret" {
  metadata {
    name      = local.conn_secret_name
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }

  data = {
    AIRFLOW_CONN_AWS_DEFAULT = jsonencode({
      conn_type = "aws"
      login = var.aws_access_key_id
      password = var.aws_secret_access_key
      extra = {
        region_name           = var.aws_region
        endpoint_url          = var.aws_endpoint_url
      }
    })
  }

  type = "Opaque"
}

resource "helm_release" "airflow" {
  name       = local.release_name
  namespace  = kubernetes_namespace.airflow.metadata[0].name
  repository = "https://airflow.apache.org"
  chart      = var.chart_name
  version    = var.chart_version

  values = [<<EOF
  extraEnvFrom: |
    - secretRef:
        name: "${local.conn_secret_name}"
  env:
    - name: AIRFLOW__LOGGING__DELETE_LOCAL_LOGS
      value: "True"
    - name: AIRFLOW__LOGGING__REMOTE_BASE_LOG_FOLDER
      value: "s3://${var.airflow_logs_bucket_name}/${var.namespace}/${local.release_name}/logs"
    - name: AIRFLOW__LOGGING__REMOTE_LOG_CONN_ID
      value: "minio_conn"
    - name: AIRFLOW__LOGGING__REMOTE_LOGGING
      value: "True"
  cleanup:
    enabled: true
    schedule: "*/15 * * * *"
    args: ["bash", "-c", "exec airflow kubernetes cleanup-pods --namespace=${var.namespace}"]
  EOF
  ]

  set = [
    {
        name = "fullnameOverride"
        value = "${local.release_name}"
    },
    {
        name = "defaultAirflowTag"
        value = var.image_tag
    },
    {
        name = "defaultAirflowRepository"
        value = var.image_repository
    },
    {
        name = "airflowVersion"
        value = var.image_tag
    },
    {
        name = "executor"
        value = "KubernetesExecutor"
    },
    {
        name = "data.metadataSecretName"
        value = local.secret_name
    },
    {
        name = "fernetKeySecretName"
        value = local.secret_name
    },
    {
        name = "apiSecretKeySecretName"
        value = local.secret_name
    },
    {
        name = "scheduler.replicas"
        value = var.airflow_scheduler_replicas
    },
    {
        name = "scheduler.logGroomerSidecar.retentionDays"
        value = var.airflow_log_retention_days
    },
    {
        name = "triggerer.enabled"
        value = var.airflow_enable_triggerer
    },
    {
        name = "triggerer.replicas"
        value = var.airflow_triggerer_replicas
    },
    {
        name = "triggerer.logGroomerSidecar.retentionDays"
        value = var.airflow_log_retention_days
    },
    {
        name = "dagProcessor.replicas"
        value = var.airflow_dag_processor_replicas
    },
    {
        name = "dagProcessor.logGroomerSidecar.retentionDays"
        value = var.airflow_log_retention_days
    },
    {
        name = "dagProcessor.enabled"
        value = var.airflow_dag_processor_enabled
    },
    {
        name = "config.scheduler.standalone_dag_processor"
        value = var.airflow_dag_processor_enabled
    },
    {
        name = "config.kubernetes_executor.namespace"
        value = var.namespace
    },
    {
        name = "dags.gitSync.enabled"
        value = var.airflow_dags_git_sync_enabled
    },
    {
        name = "config.kubernetes_executor.worker_container_repository"
        value = var.image_repository
    },
    {
        name = "config.kubernetes_executor.worker_container_tag"
        value = var.image_tag
    },
    {
        name = "dags.gitSync.repo"
        value = var.airflow_dags_git_sync_repo
    },
    {
        name = "dags.gitSync.branch"
        value = var.airflow_dags_git_sync_branch
    },
    {
        name = "dags.gitSync.rev"
        value = var.airflow_dags_git_sync_rev
    },
    {
        name = "dags.gitSync.ref"
        value = var.airflow_dags_git_sync_ref
    },
    {
        name = "dags.gitSync.subPath"
        value = var.airflow_dags_git_sync_subpath
    },
    {
        name = "dags.gitSync.sshKeySecret"
        value = local.secret_name
    },
    {
      name = "workers.logGroomerSidecar.enabled"
      value = var.enable_log_groomer_sidecar
    },
    {
      name = "scheduler.logGroomerSidecar.enabled"
      value = var.enable_log_groomer_sidecar
    },
    {
      name = "triggerer.logGroomerSidecar.enabled"
      value = var.enable_log_groomer_sidecar
    }
    ,
    {
      name = "dagProcessor.logGroomerSidecar.enabled"
      value = var.enable_log_groomer_sidecar
    },
    {
      name = "statsd.enabled"
      value = var.enable_statsd
    },
    {
      name = "workers.waitForMigrations.enabled"
      value = true
    },
    {
      name = "scheduler.waitForMigrations.enabled"
      value = true
    },
    {
      name = "apiServer.waitForMigrations.enabled"
      value = true
    },
    {
      name = "triggerer.waitForMigrations.enabled"
      value = true
    },
    {
      name = "dagProcessor.waitForMigrations.enabled"
      value = true
    },
    {
        name = "triggerer.persistence.enabled"
        value = false
    },
    {
        name = "postgresql.enabled"
        value = false
    },
    {
        name = "migrateDatabaseJob.useHelmHooks"
        value = false
    },
    {
      name = "migrateDatabaseJob.enabled"
      value = true
    },
    {
      name = "createUserJob.useHelmHooks"
      value = false
    },
    {
      name = "webserver.defaultUser.password"
      value = var.airflow_default_password
    },
  ]
}

resource "kubernetes_ingress_v1" "airflow_tailscale_funnel" {
  metadata {
    name = "${local.release_name}-funnel-service"
    namespace = var.namespace

    annotations = {
      "tailscale.com/funnel" = "${var.tailscale_funnel}"
    }
  }

  spec {
    ingress_class_name = "tailscale"

    default_backend {
      service {
        name = "${local.release_name}-api-server"

        port {
          number = 8080
        }
      }
    }

    tls {
      hosts = ["${var.prefix}.${var.tailscale_domain}"]
    }
  }
}