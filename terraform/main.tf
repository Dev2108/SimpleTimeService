provider "google" {
  project = var.gcp_project_id
  region  = "us-central1"
  credentials = file(var.gcp_credentials_file) 
}

# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "simpletimeservice-vpc"
  auto_create_subnetworks  = "false"
}

# Create Public Subnets
resource "google_compute_subnetwork" "public_subnet_1" {
  name          = "public-subnet-1"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.1.0/24"
  private_ip_google_access = false
}

resource "google_compute_subnetwork" "public_subnet_2" {
  name          = "public-subnet-2"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.2.0/24"
  private_ip_google_access = false
}

# Create Private Subnets (Not needed if Cloud Run doesn't need private VPC access)
resource "google_compute_subnetwork" "private_subnet_1" {
  name          = "private-subnet-1"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.3.0/24"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private_subnet_2" {
  name          = "private-subnet-2"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.4.0/24"
  private_ip_google_access = true
}

resource "google_cloud_run_service" "simpletimeservice" {
  name     = "simpletimeservice"
  location = "us-central1"
  
  template {
    spec {
      containers {
        image = "docker.io/pt859022535/simple-time-service:latest"
      }
    }
  }

  # No need for VPC access if no internal VPC resources are used
  autogenerate_revision_name = true
}

# Allow unauthenticated invocations
resource "google_cloud_run_service_iam_binding" "simpletimeservice_invoker" {
  service = google_cloud_run_service.simpletimeservice.name
  location = google_cloud_run_service.simpletimeservice.location

  role    = "roles/run.invoker"
  members = ["allUsers"]
}

# Output the URL of the Cloud Run service
output "cloud_run_url" {
  value = google_cloud_run_service.simpletimeservice.status[0].url
}

