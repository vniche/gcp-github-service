resource "google_cloud_run_v2_service" "cloud_run_service" {
  name     = "${var.service_name}-${terraform.workspace}"
  location = var.region
  template {
    service_account = var.service_account_email
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.image_repository}/${var.image_name}:${var.image_tag}"
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
      env {
        name = "PORT"
        value = "3333"
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

output "service_uri" {
  value = google_cloud_run_v2_service.cloud_run_service.uri
}