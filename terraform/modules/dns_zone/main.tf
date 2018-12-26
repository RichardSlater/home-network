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

resource "google_dns_record_set" "ns_records" {
  type    = "NS"
  ttl     = "300"
  rrdatas = ["${google_dns_managed_zone.prod.name_servers}"]

  managed_zone = "${google_dns_managed_zone.prod.name}"
  name         = "${google_dns_managed_zone.prod.dns_name}"
  project      = "${var.project_id}"
}

resource "google_dns_record_set" "a_record" {
  type    = "A"
  ttl     = "300"
  rrdatas = ["104.198.14.52"]

  managed_zone = "${google_dns_managed_zone.prod.name}"
  name         = "${google_dns_managed_zone.prod.dns_name}"
  project      = "${var.project_id}"
}

resource "google_dns_record_set" "www_cname_record" {
  type    = "CNAME"
  ttl     = "300"
  rrdatas = ["slaterfamily.netlify.com."]

  managed_zone = "${google_dns_managed_zone.prod.name}"
  name         = "www.${google_dns_managed_zone.prod.dns_name}"
  project      = "${var.project_id}"
}

resource "google_dns_record_set" "google_site_verification_record" {
  type    = "TXT"
  ttl     = "300"
  rrdatas = ["\"google-site-verification=_jzIcXT8j3pCLbQqPSnvTnO7xz8n2AsXGRNmg5uH7cg\""]

  managed_zone = "${google_dns_managed_zone.prod.name}"
  name         = "${google_dns_managed_zone.prod.dns_name}"
  project      = "${var.project_id}"
}

resource "google_dns_record_set" "mx_records" {
  type = "MX"
  ttl  = "300"

  rrdatas = [
    "1 ASPMX.L.GOOGLE.COM.",
    "5 ALT1.ASPMX.L.GOOGLE.COM.",
    "5 ALT2.ASPMX.L.GOOGLE.COM.",
    "10 ALT3.ASPMX.L.GOOGLE.COM.",
    "10 ALT4.ASPMX.L.GOOGLE.COM.",
  ]

  managed_zone = "${google_dns_managed_zone.prod.name}"
  name         = "${google_dns_managed_zone.prod.dns_name}"
  project      = "${var.project_id}"
}
