# modules/remote_state/main.tf
resource "google_storage_bucket" "remote-state" {
  name     = "${var.admin_project}"
  location = "europe-west2"
  force_destroy = true
}

resource "google_storage_bucket_acl" "remote-state-acl" {
  bucket         = "${google_storage_bucket.remote-state.name}"
  predefined_acl = "private"
}
