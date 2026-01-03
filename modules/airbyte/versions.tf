terraform {
  required_version = ">= 1.14.3"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1.1"
    }
  }
}

