# global/main.tf

resource "google_project" "slaterfamily_network" {
  depends_on      = [data.google_organization.org]
  name            = "Slater Family Network"
  project_id      = "slaterfamily-network"
  org_id          = data.google_organization.org.id
  billing_account = var.billing_account
}

resource "google_project_iam_binding" "account_owner" {
  project = google_project.slaterfamily_network.project_id

  # It's important to specify ALL members, as this replaces them:
  #   https://twitter.com/devopsreact/status/840233052194320384
  members = [
    "user:richard@slaterfamily.name",
    "serviceAccount:${data.google_service_account.terraform_service_account.email}",
  ]

  role = "roles/owner"
}

resource "google_project" "kubernetes_the_hard_way" {
  depends_on      = [data.google_organization.org]
  name            = "Kubernetes The Hard Way"
  project_id      = "richardslater-k8s-the-hard-way"
  org_id          = data.google_organization.org.id
  billing_account = var.billing_account
}

resource "google_project_iam_binding" "k8s_the_hard_way_account_owner" {
  project = google_project.kubernetes_the_hard_way.project_id

  # It's important to specify ALL members, as this replaces them:
  #   https://twitter.com/devopsreact/status/840233052194320384
  members = [
    "user:richard@slaterfamily.name",
    "serviceAccount:${data.google_service_account.terraform_service_account.email}",
  ]

  role = "roles/owner"
}

module "dns_zone" {
  source = "../modules/dns_zone"

  domain_name = "slaterfamily.name"
  project_id  = google_project.slaterfamily_network.id
}

