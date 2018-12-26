resource "google_project_service" "project" {
  project            = "${var.project_id}"
  service            = "dns.googleapis.com"
  disable_on_destroy = true
}

resource "google_dns_managed_zone" "prod" {
  depends_on = ["google_project_service.project"]
  name       = "${replace(var.domain_name, ".", "-")}-zone"
  dns_name   = "${var.domain_name}."
  project    = "${var.project_id}"
}
