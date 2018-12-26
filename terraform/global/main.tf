# global/main.tf

resource "google_project" "slaterfamily_network" {
  depends_on      = ["data.google_organization.org"]
  name            = "Slater Family Network"
  project_id      = "slaterfamily-network"
  org_id          = "${data.google_organization.org.id}"
  billing_account = "${var.billing_account}"
}

module "dns_zone" {
  source = "../modules/dns_zone"

  domain_name = "slaterfamily.name"
  project_id  = "${google_project.slaterfamily_network.id}"
}
