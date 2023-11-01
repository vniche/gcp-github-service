variable "service_name" {
  type        = string
  description = "The name of the service."
  default     = "my-service"
}

variable "service_account_email" {
  type        = string
  description = "The service account of the service."
}

variable "image_repository" {
  type        = string
  description = "The Artifact Registry image repository name."
}

variable "image_name" {
  type        = string
  description = "The container image name."
}

variable "image_tag" {
  type        = string
  description = "The container image tag."
}

variable "secret_name" {
  type        = string
  description = "The secret name to use for the service."
}
