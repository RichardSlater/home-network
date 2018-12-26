variable "org_id" {
  type        = "string"
  description = "Organisation ID to create resource in, imported via the TF_VAR_org_id environment variable."
}

variable "admin_project" {
  type        = "string"
  description = "The Terraform Admin Project created using bootstrap/bootstrap.sh."
}

variable "billing_account" {
  type        = "string"
  description = "The billing account, imported via the TF_VAR_billing_account environment variable."
}
