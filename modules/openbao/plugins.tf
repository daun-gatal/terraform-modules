# ============================================
# Default Plugins
# https://github.com/openbao/openbao-plugins
# ============================================

locals {
  default_plugins = [
    # GitHub Auth Plugin
    # https://github.com/openbao/openbao-plugins/pkgs/container/openbao-plugin-auth-github
    {
      name        = "github"
      image       = "ghcr.io/openbao/openbao-plugin-auth-github"
      version     = "v0.0.1"
      binary_name = "openbao-plugin-auth-github"
      sha256sum   = "4eeccf42c06ef98f6144e9f705d5c25ddf92566ff2a8f245d57522cab11ab7f5"
    }
  ]
}
