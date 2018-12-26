terraform {
  backend "gcs" {
    bucket = "richardslater-terraform-admin"
    prefix = "terraform/state/global"
  }
}
