# modules/remote_state/main.tf
resource "google_storage_bucket" "remote-state" {
  name     = "${var.admin_project}"
  location = "eu"
  storage_class = "MULTI_REGIONAL"
  force_destroy = true
  versioning {
    enabled = true
  }
  lifecycle_rule {
    condition {
      age = 28
      num_newer_versions = 3
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket_acl" "remote-state-acl" {
  bucket         = "${google_storage_bucket.remote-state.name}"
  predefined_acl = "private"
}
