provider "google" {
  project = var.admin_project
  region  = "europe-west2"
  zone    = "europe-west2-b"
  version = "~> 2.18.1"
}