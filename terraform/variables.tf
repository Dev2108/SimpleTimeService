variable "gcp_project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "gcp_region" {
  description = "Google Cloud Region"
  default     = "us-central1"
}

variable "gcp_credentials_file" {
  description = "The path to the Google Cloud service account JSON key file"
  type        = string
}

