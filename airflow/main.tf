locals {
  prefix = var.prefix
  release_name = "${local.prefix}-release"
  worker_ns = "${var.namespace}-worker"
  secret_name = "${local.prefix}-secret"
  worker_secret_name = "${local.prefix}-worker-secret"
}

resource "kubernetes_namespace" "airflow" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_namespace" "airflow_worker" {
  metadata {
    name = local.worker_ns
  }
}

resource "kubernetes_secret" "airflow_secret" {
  metadata {
    name      = local.secret_name
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }

  data = {
    connection = "postgresql://${var.airflow_db_user}:${var.airflow_db_password}@${var.airflow_db_host}:${var.airflow_db_port}/${var.airflow_db_name}"
    fernet-key = var.airflow_fernet_key
    api-secret-key = var.airflow_api_secret_key
    gitSshKey = file("${var.git_ssh_key_path}")
  }

  type = "Opaque"
}

resource "kubernetes_secret" "airflow_worker_secret" {
  metadata {
    name      = local.worker_secret_name
    namespace = kubernetes_namespace.airflow_worker.metadata[0].name
  }

  data = {
    connection = "postgresql+psycopg2://${var.airflow_db_user}:${var.airflow_db_password}@${var.airflow_db_host}:${var.airflow_db_port}/${var.airflow_db_name}"
    fernet-key = var.airflow_fernet_key
    api-secret-key = var.airflow_api_secret_key
    gitSshKey = file("${var.git_ssh_key_path}")
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
  ingress:
    web:
      enabled: ${var.enable_web_ingress}
      ingressClassName: "tailscale"
      annotations:
        tailscale.com/funnel: "${var.tailscale_funnel}"

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
    args: ["bash", "-c", "exec airflow kubernetes cleanup-pods --namespace=${local.worker_ns}"]
  EOF
  ]

  set = [
    {
        name = "fullnameOverride"
        value = "${local.release_name}"
    },
    {
        name = "defaultAirflowTag"
        value = "3.0.6"
    },
    {
        name = "airflowVersion"
        value = "3.0.6"
    },
    {
        name = "executor"
        value = "KubernetesExecutor"
    },
    {
        name = "postgresql.enabled"
        value = false
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
        name = "triggerer.persistence.enabled"
        value = var.airflow_enable_triggerer_persistence
    },
    {
        name = "triggerer.persistence.size"
        value = var.airflow_triggerer_persistence_size
    },
    {
        name = "triggerer.persistence.storageClassName"
        value = "standard"
    },
    {
        name = "triggerer.persistence.fixPermissions"
        value = var.airflow_triggerer_persistence_fix_permissions
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
        value = local.worker_ns
    },
    {
        name = "dags.gitSync.enabled"
        value = var.airflow_dags_git_sync_enabled
    },
    {
        name = "config.kubernetes_executor.worker_container_repository"
        value = var.worker_image_repository
    },
    {
        name = "config.kubernetes_executor.worker_container_tag"
        value = var.worker_image_tag
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
      name = "migrateDatabaseJob.enabled"
      value = var.airflow_wait_for_migrations
    },
    {
      name = "workers.waitForMigrations.enabled"
      value = var.airflow_wait_for_migrations
    },
    {
      name = "scheduler.waitForMigrations.enabled"
      value = var.airflow_wait_for_migrations
    },
    {
      name = "apiServer.waitForMigrations.enabled"
      value = var.airflow_wait_for_migrations
    },
    {
      name = "webserver.waitForMigrations.enabled"
      value = var.airflow_wait_for_migrations
    },
    {
      name = "triggerer.waitForMigrations.enabled"
      value = var.airflow_wait_for_migrations
    },
    {
      name = "dagProcessor.waitForMigrations.enabled"
      value = var.airflow_wait_for_migrations
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
    }
  ]

  set_sensitive = [
    {
        name = "webserver.defaultUser.password"
        value = var.airflow_web_default_password
    }
  ]
}