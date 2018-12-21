# Terraform

Configures Google Cloud and G-Suite.

Pre-requisites:

 - Google Cloud Account created.
 - Billing configured in Google Cloud.
 - `slaterfamily-terraform` project created in Google Cloud.
 - GCP Service Account created, and keyfile downloaded to `~/.gcp/slaterfamily-terraform.json`.
 - `export GOOGLE_CLOUD_KEYFILE_JSON ~/.gcp/slaterfamily-terraform.json` added to `.bash_profile` or equivalant.

Commands to execute:

    $ terraform init
    $ terraform plan
    $ terraform apply