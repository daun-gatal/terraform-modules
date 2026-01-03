provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop" # Update this to your context
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "docker-desktop" # Update this to your context
  }
}
