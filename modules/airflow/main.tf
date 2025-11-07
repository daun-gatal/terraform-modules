locals {
  prefix = var.prefix
  release_name = "${local.prefix}-release"
  secret_name = "${local.prefix}-secret"

  # Validation: SSH authentication requires git_ssh_key_path
  validate_ssh_auth = var.git_auth_method == "ssh" && var.git_ssh_key_path == null ? tobool("ERROR: git_ssh_key_path is required when git_auth_method is 'ssh'") : true

  # Validation: PAT authentication requires both git_username and git_password
  validate_pat_auth = var.git_auth_method == "pat" && (var.git_username == null || var.git_password == null) ? tobool("ERROR: git_username and git_password are required when git_auth_method is 'pat'") : true

  remote_logging_env = var.enable_remote_logging ? [
    {
      name  = "AIRFLOW__LOGGING__DELETE_LOCAL_LOGS"
      value = "True"
    },
    {
      name  = "AIRFLOW__LOGGING__REMOTE_BASE_LOG_FOLDER"
      value = "s3://${var.airflow_logs_bucket_name}/${var.namespace}/${local.release_name}/logs"
    },
    {
      name  = "AIRFLOW__LOGGING__REMOTE_LOG_CONN_ID"
      value = "minio_conn"
    },
    {
      name  = "AIRFLOW__LOGGING__REMOTE_LOGGING"
      value = "True"
    }
  ] : []
}

resource "kubernetes_secret" "airflow_secret" {
  metadata {
    name      = local.secret_name
    namespace = var.namespace
  }

  data = merge(
    {
      connection     = var.airflow_metadata_db_conn
      fernet-key     = var.airflow_fernet_key
      api-secret-key = var.airflow_api_secret_key
      basicAuth      = var.airflow_flower_credential
    },
    # SSH authentication
    var.git_auth_method == "ssh" && var.git_ssh_key_path != null ? {
      gitSshKey = file(var.git_ssh_key_path)
    } : {},
    # PAT authentication (git-sync v3)
    var.git_auth_method == "pat" && var.git_username != null && var.git_password != null ? {
      GIT_SYNC_USERNAME = var.git_username
      GIT_SYNC_PASSWORD = var.git_password
      # git-sync v4 credentials
      GITSYNC_USERNAME  = var.git_username
      GITSYNC_PASSWORD  = var.git_password
    } : {}
  )

  type = "Opaque"
}

resource "helm_release" "airflow" {
  name       = local.release_name
  namespace  = var.namespace
  repository = "https://airflow.apache.org"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    yamlencode({
      env = local.remote_logging_env

      cleanup = {
        enabled  = var.airflow_kubernetes_cleanup_enabled
        schedule = "*/15 * * * *"
        args     = [
          "bash",
          "-c",
          templatefile("${path.module}/scripts/cleanup-pods.sh", {
            namespace = var.namespace
          })
        ]
        # resources = {
        #   requests = {
        #     cpu = var.airflow_resources_config["cleanup"].requests.cpu
        #     memory = var.airflow_resources_config["cleanup"].requests.ram
        #   }
        #   limits = {
        #     cpu = var.airflow_resources_config["cleanup"].limits.cpu
        #     memory = var.airflow_resources_config["cleanup"].limits.ram
        #   }
        # }
      }

      scheduler = {
        args = [
          "bash",
          "-c",
          templatefile("${path.module}/scripts/scheduler-init.sh", {
            aws_access_key_id     = var.aws_access_key_id
            aws_secret_access_key = var.aws_secret_access_key
            aws_region           = var.aws_region
            aws_endpoint_url     = var.aws_endpoint_url
          })
        ]
        # resources = {
        #   requests = {
        #     cpu = var.airflow_resources_config["scheduler"].requests.cpu
        #     memory = var.airflow_resources_config["scheduler"].requests.ram
        #   }
        #   limits = {
        #     cpu = var.airflow_resources_config["scheduler"].limits.cpu
        #     memory = var.airflow_resources_config["scheduler"].limits.ram
        #   }
        # }
      }

      apiServer = {
        service = {
          annotations = {
            "tailscale.com/expose" = tostring(var.tailscale_expose)
            "tailscale.com/hostname" = "${local.prefix}-web-int"
          }
        }
        # resources = {
        #   requests = {
        #     cpu = var.airflow_resources_config["apiServer"].requests.cpu
        #     memory = var.airflow_resources_config["apiServer"].requests.ram
        #   }
        #   limits = {
        #     cpu = var.airflow_resources_config["apiServer"].limits.cpu
        #     memory = var.airflow_resources_config["apiServer"].limits.ram
        #   }
        # }
      }

      flower = {
        service = {
          annotations = {
            "tailscale.com/expose" = tostring(var.tailscale_expose)
            "tailscale.com/hostname" = "${local.prefix}-flower-int"
          }
        }
        # resources = {
        #   requests = {
        #     cpu = var.airflow_resources_config["flower"].requests.cpu
        #     memory = var.airflow_resources_config["flower"].requests.ram
        #   }
        #   limits = {
        #     cpu = var.airflow_resources_config["flower"].limits.cpu
        #     memory = var.airflow_resources_config["flower"].limits.ram
        #   }
        # }
      }

      workers = {
        # resources = {
        #   requests = {
        #     cpu = var.airflow_resources_config["workers"].requests.cpu
        #     memory = var.airflow_resources_config["workers"].requests.ram
        #   }
        #   limits = {
        #     cpu = var.airflow_resources_config["workers"].limits.cpu
        #     memory = var.airflow_resources_config["workers"].limits.ram
        #   }
        # }
      }

      triggerer = {
        # resources = {
        #   requests = {
        #     cpu = var.airflow_resources_config["triggerer"].requests.cpu
        #     memory = var.airflow_resources_config["triggerer"].requests.ram
        #   }
        #   limits = {
        #     cpu = var.airflow_resources_config["triggerer"].limits.cpu
        #     memory = var.airflow_resources_config["triggerer"].limits.ram
        #   }
        # }
      }

      dagProcessor = {
        # resources = {
        #   requests = {
        #     cpu = var.airflow_resources_config["dagProcessor"].requests.cpu
        #     memory = var.airflow_resources_config["dagProcessor"].requests.ram
        #   }
        #   limits = {
        #     cpu = var.airflow_resources_config["dagProcessor"].limits.cpu
        #     memory = var.airflow_resources_config["dagProcessor"].limits.ram
        #   }
        # }
      }

      dags = {
        gitSync = {
          # resources = {
          #   requests = {
          #     cpu = var.airflow_resources_config["gitSync"].requests.cpu
          #     memory = var.airflow_resources_config["gitSync"].requests.ram
          #   }
          #   limits = {
          #     cpu = var.airflow_resources_config["gitSync"].limits.cpu
          #     memory = var.airflow_resources_config["gitSync"].limits.ram
          #   }
          # }
        }
      }

      redis = {
        # resources = {
        #   requests = {
        #     cpu = var.airflow_resources_config["redis"].requests.cpu
        #     memory = var.airflow_resources_config["redis"].requests.ram
        #   }
        #   limits = {
        #     cpu = var.airflow_resources_config["redis"].limits.cpu
        #     memory = var.airflow_resources_config["redis"].limits.ram
        #   }
        # }
      }

      statsd = {
        # resources = {
        #   requests = {
        #     cpu = var.airflow_resources_config["statsd"].requests.cpu
        #     memory = var.airflow_resources_config["statsd"].requests.ram
        #   }
        #   limits = {
        #     cpu = var.airflow_resources_config["statsd"].limits.cpu
        #     memory = var.airflow_resources_config["statsd"].limits.ram
        #   }
        # }
      }
    })
  ]

  set = concat([
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
        value = var.airflow_executor
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
    {
      name = "workers.replicas"
      value = var.airflow_worker_replicas
    },
    {
      name = "workers.keda.enabled"
      value = var.airflow_worker_keda_enabled
    },
    {
      name = "workers.keda.minReplicaCount"
      value = var.airflow_worker_keda_min_replicas
    },
    {
      name = "workers.keda.maxReplicaCount"
      value = var.airflow_worker_keda_max_replicas
    },
    {
      name = "workers.persistence.enabled"
      value = false
    },
    {
      name = "workers.logGroomerSidecar.enabled"
      value = var.enable_log_groomer_sidecar
    },
    {
      name = "flower.enabled"
      value = var.airflow_flower_enabled
    },
    {
      name = "flower.secretName"
      value = local.secret_name
    },
    {
      name = "redis.persistence.enabled"
      value = false
    },
    {
      name = "multiNamespaceMode"
      value = true
    }
  ],
  # Conditionally add SSH authentication configuration
  var.git_auth_method == "ssh" ? [
    {
      name  = "dags.gitSync.sshKeySecret"
      value = local.secret_name
    }
  ] : [],
  # Conditionally add PAT authentication configuration
  var.git_auth_method == "pat" ? [
    {
      name  = "dags.gitSync.credentialsSecret"
      value = local.secret_name
    }
  ] : []
  )
}