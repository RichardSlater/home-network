# global/main.tf
terraform {
  backend "gcs" {
    bucket = "slaterfamily-remote-state-global"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "slaterfamily-terraform"
  region  = "europe-west2"
  zone    = "europe-west2-b"
  version = "~> 1.20"
}

data "google_organization" "org" {
  organization = "862145970828"
}

resource "google_project" "slaterfamily_wifi" {
  depends_on = ["data.google_organization.org"]
  name       = "Slater Family WiFi"
  project_id = "slaterfamily-wifi"
  org_id     = "${data.google_organization.org.org_id}"
}
