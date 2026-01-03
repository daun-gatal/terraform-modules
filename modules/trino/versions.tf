terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.16"
    }
    htpasswd = {
      source  = "loafoe/htpasswd"
      version = "~> 1.2.1"
    }
  }
}
