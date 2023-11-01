resource "google_cloud_run_v2_service" "cloud_run_service" {
  name     = "${var.service_name}-${terraform.workspace}"
  location = var.region
  template {
    service_account = var.service_account_email
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.image_repository}/${var.image_name}:${var.image_tag}"
      ports {
        container_port = 3333
      }
      resources {
        limits = {
          "cpu" : 1,
          "memory" : "512Mi",
        }
      }
      env {
        name  = "SECRET_PATH"
        value = "/secret/${var.secret_name}"
      }
      volume_mounts {
        name       = "secret"
        mount_path = "/secret/"
      }
    }
    volumes {
      name = "secret"
      secret {
        secret = var.secret_name
        items {
          path    = var.secret_name
          version = "latest"
          mode    = 0444
        }
      }
    }
  }
}

resource "google_cloud_run_service_iam_binding" "default" {
  location = google_cloud_run_v2_service.cloud_run_service.location
  service  = google_cloud_run_v2_service.cloud_run_service.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}

output "service_uri" {
  value = google_cloud_run_v2_service.cloud_run_service.uri
}