terraform {
  required_version = ">= 1.14.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0.1"

    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
  }
}
