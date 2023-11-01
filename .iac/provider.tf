terraform {
  backend "gcs" {
    bucket = "cloud-run-995654ca-7387-9dd3-46e3-7910e705103d"
    prefix = "tofu/state/service"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.1.0"
    }
  }
}

provider "google" {
  region  = var.region
  project = var.project_id
}
