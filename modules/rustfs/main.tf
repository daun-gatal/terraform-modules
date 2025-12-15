locals {
  # Default values - only mandatory configurations
  default_values = {
    # Fullname override
    fullnameOverride = var.fullname_override

    # Common labels for tailscale
    commonLabels = {
      "rustfs.tailscale.common/console" = var.fullname_override
    }

    podLabels = {
      "rustfs.tailscale.pod/console" = var.fullname_override
    }

    # Image configuration
    image = {
      registry        = var.image_registry
      repository      = var.image_repository
      tag             = var.image_tag
      imagePullPolicy = var.image_pull_policy
    }

    # Authentication (mandatory)
    auth = {
      accessKey      = var.auth_access_key
      secretKey      = var.auth_secret_key
      existingSecret = var.auth_existing_secret
    }

    # Basic deployment
    replicaCount   = var.replica_count
    deploymentType = var.deployment_type

    # Service configuration
    service = {
      type        = var.service_type
      port        = var.service_port
      consolePort = var.service_console_port
      annotations = var.service_annotations
    }

    # Resources
    resources = var.resources

    # Disable ingress by default
    ingress = {
      enabled = false
    }
    consoleIngress = {
      enabled = false
    }

    # Disable console service by default
    consoleService = {
      enabled = false
    }
  }

  # Merge default values with user-provided values
  merged_values = merge(local.default_values, var.values)
}

resource "helm_release" "rustfs" {
  name       = var.release_name
  namespace  = var.namespace
  repository = "oci://registry-1.docker.io/cloudpirates"
  chart      = "rustfs"
  version    = var.chart_version

  values = [
    yamlencode(local.merged_values)
  ]
}

resource "kubernetes_service" "rustfs_custom_service" {
  metadata {
    name      = "${var.fullname_override}-custom-service"
    namespace = var.namespace
    labels = {
      app = var.fullname_override
    }
    annotations = {
      "tailscale.com/expose"   = "${var.tailscale_expose}"
      "tailscale.com/hostname" = "${var.fullname_override}-int"
    }
  }

  spec {
    selector = {
      "rustfs.tailscale.common/console" = var.fullname_override
      "rustfs.tailscale.pod/console"    = var.fullname_override
    }

    port {
      name        = "${var.fullname_override}-custom-console"
      port        = 9001
      target_port = 9001
    }

    port {
      name        = "${var.fullname_override}-custom-api"
      port        = 9000
      target_port = 9000
    }

    type = "ClusterIP"
  }
}