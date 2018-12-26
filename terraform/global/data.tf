data "google_organization" "org" {
  # yes technically, we already know the org_id however this
  # validates it and we may need the org object in the future
  organization = "${var.org_id}"
}
