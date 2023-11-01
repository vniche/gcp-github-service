variable "project_id" {
  type        = string
  description = "The Google Cloud Platform project id."
}

variable "region" {
  type        = string
  description = "The Google Cloud Platform region."
  default     = "us-central1"
}
