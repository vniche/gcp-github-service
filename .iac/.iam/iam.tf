variable "service_name" {
  type        = string
  description = "The name of the service."
  default     = "my-service"
}

variable "secret_name" {
  type        = string
  description = "The secret name to use for the service."
}

variable "cicd_service_account_id" {
  type        = string
  description = "The CI/CD service account id."
}

resource "google_service_account" "cloud_run_service_account" {
  account_id = "${var.service_name}-${terraform.workspace}"
}

resource "google_service_account_iam_member" "cloud_run_service_accoun_user" {
  service_account_id = google_service_account.cloud_run_service_account.id
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${var.cicd_service_account_id}@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_secret_manager_secret_iam_member" "cloud_run_secret_member" {
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
  secret_id  = var.secret_name
}

resource "google_project_iam_member" "cloud_run_service_account_membership" {
  project = var.project_id
  member  = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
  role    = "roles/run.invoker"
}
