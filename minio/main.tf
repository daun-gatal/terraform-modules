# MinIO Development-Focused Deployment
# Simplified for development with minimal configuration

locals {
  tenant_name = var.tenant_name
  secret_name = "${local.tenant_name}-secret"
  minio_image = "${var.image_repository}:${var.image_tag}"
  
  # Development defaults
  servers = var.enable_distributed ? 4 : 1
  volumes_per_server = 1
}

# Create namespace
resource "kubernetes_namespace" "minio" {
  metadata {
    name = var.namespace
  }
}

# Apply resource limits to the MinIO namespace
module "minio_resources" {
  source = "../resource"
  
  namespace = kubernetes_namespace.minio.metadata[0].name
  cpu       = var.cpu_allocation
  memory    = var.memory_allocation
}

# Create simple secret for credentials
resource "kubernetes_secret" "minio_credentials" {
  metadata {
    name      = local.secret_name
    namespace = kubernetes_namespace.minio.metadata[0].name
  }

  data = {
    "config.env" = <<-EOT
      export MINIO_ROOT_USER=${var.minio_root_user}
      export MINIO_ROOT_PASSWORD=${var.minio_root_password}
    EOT
  }

  type = "Opaque"
}

# MinIO Tenant (simplified for development)
resource "kubernetes_manifest" "minio_tenant" {
  depends_on = [kubernetes_secret.minio_credentials]

  manifest = {
    apiVersion = "minio.min.io/v2"
    kind       = "Tenant"
    metadata = {
      name      = local.tenant_name
      namespace = var.namespace
    }
    spec = {
      # Basic configuration
      image             = local.minio_image
      imagePullPolicy   = "IfNotPresent"
      
      # Configuration secret
      configuration = {
        name = kubernetes_secret.minio_credentials.metadata[0].name
      }
      
      # Simple pool configuration
      pools = [
        {
          name             = "pool"
          servers          = local.servers
          volumesPerServer = local.volumes_per_server
          
          # Storage
          volumeClaimTemplate = {
            metadata = {
              name = "data"
            }
            spec = {
              accessModes = ["ReadWriteOnce"]
              resources = {
                requests = {
                  storage = var.storage_size
                }
              }
              storageClassName = var.storage_class_name
            }
          }
          
          # Basic security context
          securityContext = {
            runAsUser    = 1000
            runAsGroup   = 1000
            runAsNonRoot = true
            fsGroup      = 1000
          }
          
          # Container security
          containerSecurityContext = {
            runAsUser                = 1000
            runAsGroup               = 1000
            runAsNonRoot             = true
            allowPrivilegeEscalation = false
            capabilities = {
              drop = ["ALL"]
            }
          }
        }
      ]
      
      # Simple mount paths
      mountPath = "/export"
      subPath   = "/data"
      
      # Pod management
      podManagementPolicy = "Parallel"
      
      # TLS configuration (simplified for development)
      requestAutoCert = var.enable_tls
      
      # Service metadata for Tailscale exposure
      serviceMetadata = {
        consoleServiceAnnotations = {
          "tailscale.com/expose"   = tostring(var.tailscale_expose)
          "tailscale.com/hostname" = "${local.tenant_name}-console"
        }
      }
      
      # Bucket creation during tenant provisioning
      buckets = [
        for bucket in var.buckets : {
          name       = bucket.name
          region     = bucket.region
        }
      ]
    }
  }
}

# Job to apply lifecycle/retention policies for buckets
resource "kubernetes_job" "apply_bucket_policies" {
  count      = length([for b in var.buckets : b if b.expire_days != null || b.noncurrent_expire_days != null]) > 0 ? 1 : 0
  depends_on = [kubernetes_manifest.minio_tenant]
  
  metadata {
    name      = "${local.tenant_name}-bucket-policies"
    namespace = kubernetes_namespace.minio.metadata[0].name
  }
  
  spec {
    template {
      metadata {}
      spec {
        restart_policy = "OnFailure"
        container {
          name  = "mc"
          image = "minio/mc:latest"
          command = [
            "/bin/sh",
            "-c",
            templatefile("${path.module}/scripts/apply-policies.sh", {
              tenant_name = local.tenant_name
              namespace   = var.namespace
              buckets     = var.buckets
              username    = var.minio_root_user
              password    = var.minio_root_password
            })
          ]
        }
      }
    }
    backoff_limit = 3
  }

  wait_for_completion = true
  timeouts {
    create = "5m"
    update = "5m"
  }
}

# Services and buckets are automatically created by MinIO Operator