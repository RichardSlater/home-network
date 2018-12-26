# state/variables.tf
variable "environment" {
  default     = "global"
  description = "Environment Name"
}

variable "admin_project" {
  type        = "string"
  description = "The Terraform Admin Project created using bootstrap/bootstrap.sh"
}
