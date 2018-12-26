output "name_servers" {
  depends_on = ["google_dns_managed_zone.prod"]
  value      = "${google_dns_managed_zone.prod.name_servers}"
}
