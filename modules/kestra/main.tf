locals {
  prefix       = var.prefix
  release_name = "${local.prefix}-release"

  # Default values following the Helm chart structure
  default_values = {
    # Fullname override
    fullnameOverride = local.release_name

    # Image configuration
    image = {
      repository = var.image_repository
      pullPolicy = var.image_pull_policy
      tag        = var.image_tag
    }

    imagePullSecrets = var.image_pull_secrets

    # Common settings
    common = {
      replicas  = var.replicas
      resources = var.resources

      autoscaler = {
        enabled     = var.autoscaler_enabled
        minReplicas = var.autoscaler_min_replicas
        maxReplicas = var.autoscaler_max_replicas
        metrics     = var.autoscaler_metrics
      }
    }

    # Kestra configurations
    configurations = {
      application = var.application_config
      secrets     = var.configuration_secrets
      configmaps  = var.configuration_configmaps
    }

    # Deployments - based on deployment mode
    deployments = {
      standalone = {
        enabled       = var.deployment_mode == "standalone"
        workerThreads = var.worker_threads
        dind = {
          enabled = var.dind_enabled
        }
      }
      webserver = { enabled = var.deployment_mode == "distributed" }
      executor  = { enabled = var.deployment_mode == "distributed" }
      indexer   = { enabled = var.deployment_mode == "distributed" }
      scheduler = { enabled = var.deployment_mode == "distributed" }
      worker = {
        enabled       = var.deployment_mode == "distributed"
        workerThreads = var.worker_threads
      }
    }

    # Docker-in-Docker configuration
    dind = {
      enabled   = var.dind_enabled
      mode      = var.dind_mode
      resources = var.dind_resources
    }

    # Service configuration
    service = {
      type = var.service_type
      annotations = merge(
        var.service_annotations,
        var.tailscale_expose ? {
          "tailscale.com/expose"   = "true"
          "tailscale.com/hostname" = "${local.prefix}-int"
        } : {}
      )
    }
  }

  # Merge default values with user-provided values
  merged_values = merge(local.default_values, var.values)
}

resource "helm_release" "kestra" {
  name       = local.release_name
  namespace  = var.namespace
  repository = var.chart_repository
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    yamlencode(local.merged_values)
  ]
}

