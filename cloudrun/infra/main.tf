terraform {
  backend "gcs" {
    prefix = "cloudrun-ondev"
    bucket = "cubicbi-dev-tf-state"
  }
}

variable "project_id" {
  type        = string
  description = "Project ID to deploy resources in."
  default = "cubicbi-dev"
}

resource "google_cloud_run_service" "default" {
  name     = "gcp-cloud-run-tf-v2-using-cloudbuild-image"
  location = "europe-west2"
  project = var.project_id

  template {
    spec {
      timeout_seconds = 600
      containers {
        image = "gcr.io/cubicbi-dev/cloudrun:latest"  
        #"gcr.io/cubicbi-cloudrun/gcp-cloud-run-v-2"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}


data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
