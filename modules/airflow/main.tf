locals {
  prefix       = var.prefix
  release_name = "${local.prefix}-release"
  secret_name  = "${local.prefix}-secret"

  # Validation: SSH authentication requires git_ssh_key_path
  validate_ssh_auth = var.git_auth_method == "ssh" && var.git_ssh_key_path == null ? tobool("ERROR: git_ssh_key_path is required when git_auth_method is 'ssh'") : true

  # Validation: PAT authentication requires both git_username and git_password
  validate_pat_auth = var.git_auth_method == "pat" && (var.git_username == null || var.git_password == null) ? tobool("ERROR: git_username and git_password are required when git_auth_method is 'pat'") : true

  # Remote logging environment variables
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

  # Default values - structured like rustfs pattern
  default_values = {
    # Fullname override
    fullnameOverride = local.release_name

    # Environment variables
    env = local.remote_logging_env

    # Image configuration
    defaultAirflowTag        = var.image_tag
    defaultAirflowRepository = var.image_repository
    airflowVersion           = var.image_tag

    images = {
      airflow = {
        pullPolicy = "Always"
      }
    }

    # Executor configuration
    executor = var.airflow_executor

    # Secret references
    data = {
      metadataSecretName = local.secret_name
    }
    fernetKeySecretName    = local.secret_name
    apiSecretKeySecretName = local.secret_name

    # Webserver configuration
    webserver = {
      defaultUser = {
        password = var.airflow_default_password
      }
    }

    # Scheduler configuration
    scheduler = {
      replicas = var.airflow_scheduler_replicas
      args = [
        "bash",
        "-c",
        templatefile("${path.module}/scripts/scheduler-init.sh", {
          aws_access_key_id     = var.aws_access_key_id
          aws_secret_access_key = var.aws_secret_access_key
          aws_region            = var.aws_region
          aws_endpoint_url      = var.aws_endpoint_url
        })
      ]
      resources = {
        requests = {
          cpu    = var.airflow_resources_config["scheduler"].requests.cpu
          memory = var.airflow_resources_config["scheduler"].requests.ram
        }
        limits = {
          cpu    = var.airflow_resources_config["scheduler"].limits.cpu
          memory = var.airflow_resources_config["scheduler"].limits.ram
        }
      }
      logGroomerSidecar = {
        enabled       = var.enable_log_groomer_sidecar
        retentionDays = var.airflow_log_retention_days
      }
      waitForMigrations = {
        enabled = true
      }
    }

    # API Server configuration
    apiServer = {
      apiServerConfig = var.airflow_api_server_config
      service = {
        annotations = {
          "tailscale.com/expose"   = tostring(var.tailscale_expose)
          "tailscale.com/hostname" = "${local.prefix}-web-int"
        }
      }
      resources = {
        requests = {
          cpu    = var.airflow_resources_config["apiServer"].requests.cpu
          memory = var.airflow_resources_config["apiServer"].requests.ram
        }
        limits = {
          cpu    = var.airflow_resources_config["apiServer"].limits.cpu
          memory = var.airflow_resources_config["apiServer"].limits.ram
        }
      }
      waitForMigrations = {
        enabled = true
      }
    }

    # Triggerer configuration
    triggerer = {
      enabled  = var.airflow_enable_triggerer
      replicas = var.airflow_triggerer_replicas
      resources = {
        requests = {
          cpu    = var.airflow_resources_config["triggerer"].requests.cpu
          memory = var.airflow_resources_config["triggerer"].requests.ram
        }
        limits = {
          cpu    = var.airflow_resources_config["triggerer"].limits.cpu
          memory = var.airflow_resources_config["triggerer"].limits.ram
        }
      }
      persistence = {
        enabled = false
      }
      logGroomerSidecar = {
        enabled       = var.enable_log_groomer_sidecar
        retentionDays = var.airflow_log_retention_days
      }
      waitForMigrations = {
        enabled = true
      }
    }

    # DAG Processor configuration
    dagProcessor = {
      enabled  = var.airflow_dag_processor_enabled
      replicas = var.airflow_dag_processor_replicas
      resources = {
        requests = {
          cpu    = var.airflow_resources_config["dagProcessor"].requests.cpu
          memory = var.airflow_resources_config["dagProcessor"].requests.ram
        }
        limits = {
          cpu    = var.airflow_resources_config["dagProcessor"].limits.cpu
          memory = var.airflow_resources_config["dagProcessor"].limits.ram
        }
      }
      logGroomerSidecar = {
        enabled       = var.enable_log_groomer_sidecar
        retentionDays = var.airflow_log_retention_days
      }
      waitForMigrations = {
        enabled = true
      }
    }

    # Workers configuration
    workers = {
      replicas = var.airflow_worker_replicas
      resources = {
        requests = {
          cpu    = var.airflow_resources_config["workers"].requests.cpu
          memory = var.airflow_resources_config["workers"].requests.ram
        }
        limits = {
          cpu    = var.airflow_resources_config["workers"].limits.cpu
          memory = var.airflow_resources_config["workers"].limits.ram
        }
      }
      persistence = {
        enabled = false
      }
      logGroomerSidecar = {
        enabled = var.enable_log_groomer_sidecar
      }
      waitForMigrations = {
        enabled = true
      }
      keda = {
        enabled         = var.airflow_worker_keda_enabled
        minReplicaCount = var.airflow_worker_keda_min_replicas
        maxReplicaCount = var.airflow_worker_keda_max_replicas
      }
    }

    # Flower configuration
    flower = {
      enabled    = var.airflow_flower_enabled
      secretName = local.secret_name
      service = {
        annotations = {
          "tailscale.com/expose"   = tostring(var.tailscale_expose)
          "tailscale.com/hostname" = "${local.prefix}-flower-int"
        }
      }
      resources = {
        requests = {
          cpu    = var.airflow_resources_config["flower"].requests.cpu
          memory = var.airflow_resources_config["flower"].requests.ram
        }
        limits = {
          cpu    = var.airflow_resources_config["flower"].limits.cpu
          memory = var.airflow_resources_config["flower"].limits.ram
        }
      }
    }

    # Cleanup job configuration
    cleanup = {
      enabled  = var.airflow_kubernetes_cleanup_enabled
      schedule = "*/15 * * * *"
      args = [
        "bash",
        "-c",
        templatefile("${path.module}/scripts/cleanup-pods.sh", {
          namespace = var.namespace
        })
      ]
      resources = {
        requests = {
          cpu    = var.airflow_resources_config["cleanup"].requests.cpu
          memory = var.airflow_resources_config["cleanup"].requests.ram
        }
        limits = {
          cpu    = var.airflow_resources_config["cleanup"].limits.cpu
          memory = var.airflow_resources_config["cleanup"].limits.ram
        }
      }
    }

    # DAGs git-sync configuration
    dags = {
      gitSync = merge(
        {
          enabled = var.airflow_dags_git_sync_enabled
          repo    = var.airflow_dags_git_sync_repo
          branch  = var.airflow_dags_git_sync_branch
          rev     = var.airflow_dags_git_sync_rev
          ref     = var.airflow_dags_git_sync_ref
          subPath = var.airflow_dags_git_sync_subpath
          resources = {
            requests = {
              cpu    = var.airflow_resources_config["gitSync"].requests.cpu
              memory = var.airflow_resources_config["gitSync"].requests.ram
            }
            limits = {
              cpu    = var.airflow_resources_config["gitSync"].limits.cpu
              memory = var.airflow_resources_config["gitSync"].limits.ram
            }
          }
        },
        # SSH authentication
        var.git_auth_method == "ssh" ? {
          sshKeySecret = local.secret_name
        } : {},
        # PAT authentication
        var.git_auth_method == "pat" ? {
          credentialsSecret = local.secret_name
        } : {}
      )
    }

    # Redis configuration
    redis = {
      resources = {
        requests = {
          cpu    = var.airflow_resources_config["redis"].requests.cpu
          memory = var.airflow_resources_config["redis"].requests.ram
        }
        limits = {
          cpu    = var.airflow_resources_config["redis"].limits.cpu
          memory = var.airflow_resources_config["redis"].limits.ram
        }
      }
      persistence = {
        enabled = false
      }
    }

    # StatsD configuration
    statsd = {
      enabled = var.enable_statsd
      resources = {
        requests = {
          cpu    = var.airflow_resources_config["statsd"].requests.cpu
          memory = var.airflow_resources_config["statsd"].requests.ram
        }
        limits = {
          cpu    = var.airflow_resources_config["statsd"].limits.cpu
          memory = var.airflow_resources_config["statsd"].limits.ram
        }
      }
    }

    # Airflow config
    config = {
      scheduler = {
        standalone_dag_processor = var.airflow_dag_processor_enabled
      }
      kubernetes_executor = {
        namespace                   = var.namespace
        worker_container_repository = var.image_repository
        worker_container_tag        = var.image_tag
      }
    }

    # Disable built-in PostgreSQL (using external)
    postgresql = {
      enabled = false
    }

    # Migration job configuration
    migrateDatabaseJob = {
      enabled      = true
      useHelmHooks = false
    }

    # Create user job configuration
    createUserJob = {
      useHelmHooks = false
    }

    # Multi-namespace mode
    multiNamespaceMode = true
  }

  # Merge default values with user-provided values
  merged_values = merge(local.default_values, var.values)
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
    # PAT authentication (git-sync v3 and v4)
    var.git_auth_method == "pat" && var.git_username != null && var.git_password != null ? {
      GIT_SYNC_USERNAME = var.git_username
      GIT_SYNC_PASSWORD = var.git_password
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
    yamlencode(local.merged_values)
  ]

  depends_on = [kubernetes_secret.airflow_secret]
}
