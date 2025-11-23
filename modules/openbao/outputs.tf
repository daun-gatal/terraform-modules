# -------------------------------
# Server Service DNS + Port
# -------------------------------
output "openbao_server_dns" {
  value       = "${var.openbao_fullname_override}-active.${var.openbao_namespace}.svc.cluster.local:8200"
  description = "Full DNS and port for the OpenBao server service"
}
