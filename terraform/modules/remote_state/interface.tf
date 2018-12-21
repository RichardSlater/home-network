variable "prefix" {
  default     = "slaterfamily"
  description = "Organisation Name to prefix buckets with"
}

variable "environment" {
  default     = "global"
  description = "Environment Name"
}

resource "google_project_service" "storage-component" {
  service = "storage-component.googleapis.com"
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_project_service" "resource-manager" {
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_storage_bucket" "remote-state" {
  depends_on = [
    "google_project_service.compute",
    "google_project_service.storage-component",
    "google_project_service.resource-manager",
  ]

  name     = "${var.prefix}-remote-state-${var.environment}"
  location = "europe-west2"
}

resource "google_storage_bucket_acl" "remote-state-acl" {
  bucket         = "${google_storage_bucket.remote-state.name}"
  predefined_acl = "private"
}
