    resource "google_project_service" "service_usage" {
      project = "${var.project_id}"
      service = "serviceusage.googleapis.com"
    }
    
    resource "google_project_service" "maps" {
      depends_on = ["google_project_service.service_usage"]
      project = "${var.project_id}"
      service = "maps.googleapis.com"
    }
