locals {
  prefix       = var.prefix
  release_name = "${local.prefix}-release"

  # Packages to install via pip
  pip_packages = join(" ", var.bootstrap_pip_packages)

  # Default values - structured like airflow pattern
  default_values = {
    # Fullname override
    fullnameOverride = local.release_name

    envFromSecret = var.superset_secret_name

    # Bootstrap script to install extra pip packages using uv
    bootstrapScript = <<-EOT
    #!/bin/bash
    set -e

    if [ -n "${local.pip_packages}" ]; then
      echo "Installing packages using uv: ${local.pip_packages}"
      uv pip install psycopg2-binary redis Authlib ${local.pip_packages} --python /app/.venv/bin/python
    fi

    if [ ! -f ~/bootstrap ]; then
      echo "Running Superset with uid 0" > ~/bootstrap
    fi
    EOT

    # Image configuration
    image = {
      repository = var.image_repository
      tag        = var.image_tag
      pullPolicy = var.image_pull_policy
    }

    # Bootstrap configuration
    init = {
      adminUser = {
        username  = var.admin_username
        firstname = var.admin_firstname
        lastname  = var.admin_lastname
        email     = var.admin_email
        password  = var.admin_password
      }
    }

    service = {
      type = var.service_type
      port = var.tailscale_expose ? 80 : 8088
      annotations = {
        "tailscale.com/expose"   = "${var.tailscale_expose}"
        "tailscale.com/hostname" = "${local.prefix}-web-int"
      }
    }

    # Superset node (web server)
    supersetNode = {
      replicaCount = var.superset_node_replicas
      resources = {
        requests = {
          cpu    = var.superset_resources_config["supersetNode"].requests.cpu
          memory = var.superset_resources_config["supersetNode"].requests.ram
        }
        limits = {
          cpu    = var.superset_resources_config["supersetNode"].limits.cpu
          memory = var.superset_resources_config["supersetNode"].limits.ram
        }
      }
    }

    # Superset worker (Celery)
    supersetWorker = {
      enabled      = var.enable_celery_worker
      replicaCount = var.celery_worker_replicas
      resources = {
        requests = {
          cpu    = var.superset_resources_config["supersetWorker"].requests.cpu
          memory = var.superset_resources_config["supersetWorker"].requests.ram
        }
        limits = {
          cpu    = var.superset_resources_config["supersetWorker"].limits.cpu
          memory = var.superset_resources_config["supersetWorker"].limits.ram
        }
      }
    }

    # Celery beat (scheduler)
    supersetCeleryBeat = {
      enabled = var.enable_celery_beat
      resources = {
        requests = {
          cpu    = var.superset_resources_config["supersetCeleryBeat"].requests.cpu
          memory = var.superset_resources_config["supersetCeleryBeat"].requests.ram
        }
        limits = {
          cpu    = var.superset_resources_config["supersetCeleryBeat"].limits.cpu
          memory = var.superset_resources_config["supersetCeleryBeat"].limits.ram
        }
      }
    }

    # Celery Flower (monitoring)
    supersetCeleryFlower = {
      enabled = var.enable_celery_flower
      resources = {
        requests = {
          cpu    = var.superset_resources_config["supersetCeleryFlower"].requests.cpu
          memory = var.superset_resources_config["supersetCeleryFlower"].requests.ram
        }
        limits = {
          cpu    = var.superset_resources_config["supersetCeleryFlower"].limits.cpu
          memory = var.superset_resources_config["supersetCeleryFlower"].limits.ram
        }
      }
    }

    # Websocket server
    supersetWebsockets = {
      enabled = var.enable_websockets
      resources = {
        requests = {
          cpu    = var.superset_resources_config["supersetWebsockets"].requests.cpu
          memory = var.superset_resources_config["supersetWebsockets"].requests.ram
        }
        limits = {
          cpu    = var.superset_resources_config["supersetWebsockets"].limits.cpu
          memory = var.superset_resources_config["supersetWebsockets"].limits.ram
        }
      }
    }

    # Built-in PostgreSQL configuration
    postgresql = {
      enabled = !var.use_external_database
      image = {
        tag = "latest"
      }
    }

    # Built-in Redis configuration
    redis = {
      enabled = !var.use_external_redis
      image = {
        tag = "latest"
      }
    }

    # Configuration overrides for secrets
    configOverrides = {
      secret = <<-EOT
      SECRET_KEY = os.environ.get('SUPERSET_SECRET_KEY')
      EOT
      enable_oauth = var.oauth_config
    }

    # Init job configuration
    initJob = {
      resources = {
        requests = {
          cpu    = var.superset_resources_config["initJob"].requests.cpu
          memory = var.superset_resources_config["initJob"].requests.ram
        }
        limits = {
          cpu    = var.superset_resources_config["initJob"].limits.cpu
          memory = var.superset_resources_config["initJob"].limits.ram
        }
      }
    }
  }

  # Merge default values with user-provided values
  merged_values = merge(local.default_values, var.values)
}

resource "helm_release" "superset" {
  name       = local.release_name
  namespace  = var.namespace
  repository = "https://apache.github.io/superset"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    yamlencode(local.merged_values)
  ]
}
