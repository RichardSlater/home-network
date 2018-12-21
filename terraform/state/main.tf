# state/main.tf
provider "google" {
  project = "slaterfamily-terraform"
  region  = "europe-west2"
  zone    = "europe-west2-b"
  version = "~> 1.20"
}

module "remote_state_global" {
  source = "../modules/remote_state"

  environment = "global"
}

module "remote_state_eu" {
  source = "../modules/remote_state"

  environment = "eu"
}