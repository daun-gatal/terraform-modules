locals {
  default_spec = {
    instances = var.instances

    db = {
      vendor   = var.db_vendor
      host     = var.db_host
      port     = var.db_port
      database = var.db_database
      usernameSecret = {
        name = var.db_username_secret.name
        key  = var.db_username_secret.key
      }
      passwordSecret = {
        name = var.db_password_secret.name
        key  = var.db_password_secret.key
      }
    }

    hostname = {
      hostname = var.hostname
      strict   = var.hostname_strict
    }

    http = {
      httpEnabled = var.http_enabled
    }

    ingress = {
      enabled = var.ingress_enabled
    }

    additionalOptions = [
      {
        name = "features"
        value = "token-exchange,legacy-token-exchange"
      }
    ]

    proxy = {
      headers = var.proxy_headers
    }
  }
}

resource "kubernetes_manifest" "keycloak" {
  manifest = {
    apiVersion = "k8s.keycloak.org/v2alpha1"
    kind       = "Keycloak"
    metadata = {
      name      = var.name
      namespace = var.namespace
    }
    spec = local.default_spec
  }
}

resource "kubernetes_service" "keycloak" {
  metadata {
    name      = "${var.name}-custom-service"
    namespace = var.namespace
    labels = {
      app                            = "keycloak"
      "app.kubernetes.io/instance"   = var.name
      "app.kubernetes.io/managed-by" = "keycloak-operator"
    }
    annotations = merge(
      var.service.annotations,
      var.tailscale_expose ? {
        "tailscale.com/expose"   = "true"
        "tailscale.com/hostname" = "${var.name}-web-int"
      } : {}
    )
  }

  spec {
    selector = {
      app                            = "keycloak"
      "app.kubernetes.io/instance"   = var.name
      "app.kubernetes.io/managed-by" = "keycloak-operator"
    }

    type = var.service.type

    port {
      name        = var.service.port.name
      port        = var.service.port.port
      target_port = var.service.port.targetPort
    }
  }
}

resource "kubernetes_ingress_v1" "keycloak" {
  count = var.tailscale_funnel ? 1 : 0

  metadata {
    name      = "${var.name}-custom-ingress"
    namespace = var.namespace
    annotations = {
      "tailscale.com/funnel" = "true"
    }
  }

  spec {
    ingress_class_name = "tailscale"

    tls {
      hosts = ["${var.name}-web-ext"]
    }

    rule {
      host = "${var.name}-web-ext"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.keycloak.metadata[0].name
              port {
                number = var.service.port.port
              }
            }
          }
        }
      }
    }
  }
}
