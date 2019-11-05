$env:TF_VAR_org_id = "862145970828"
$env:TF_VAR_billing_account = "01D50D-302263-962D85"
$env:TF_VAR_admin_project = "richardslater-terraform-admin"
$env:TF_CREDS = (Resolve-Path "~\.gcp\richardslater-terraform-admin-7c0594102c8c.json").Path
$env:GOOGLE_APPLICATION_CREDENTIALS = $env:TF_CREDS
$env:GOOGLE_PROJECT = $env:TF_VAR_admin_project
