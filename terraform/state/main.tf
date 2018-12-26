# state/main.tf

module "remote_state" {
  source = "../modules/remote_state"

  environment   = "global"
  admin_project = "${var.admin_project}"
}
