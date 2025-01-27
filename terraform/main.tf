provider "google" {
  project = var.gcp_project_id
  region  = "us-central1"
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

# Create Private Subnets
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

# Create a Cloud Run Service for the SimpleTimeService Docker Container
resource "google_cloud_run_service" "simpletimeservice" {
  name     = "simpletimeservice"
  location = "us-central1"
  template {
    spec {
      containers {
        image = "gcr.io/${var.gcp_project_id}/simpletimeservice:latest"
      }
    }
  }

  # Configure service to be accessible from private subnets
  vpc_access {
    connector = google_vpc_access_connector.private_vpc_connector.id
  }
}

# VPC Access Connector for Cloud Run (to allow access to private subnets)
resource "google_vpc_access_connector" "private_vpc_connector" {
  name     = "private-vpc-connector"
  region   = "us-central1"
  network  = google_compute_network.vpc.id
  subnet   = google_compute_subnetwork.private_subnet_1.name
}

# Create an API Gateway to expose the Cloud Run service
resource "google_api_gateway_api" "simpletimeservice_api" {
  name     = "simpletimeservice-api"
  api_id   = "simpletimeservice-api-id"
  region   = "us-central1"
}

resource "google_api_gateway_api_config" "simpletimeservice_api_config" {
  api      = google_api_gateway_api.simpletimeservice_api.id
  name     = "simpletimeservice-api-config"
  region   = "us-central1"

  gateway_config {
    api_url = "https://${google_cloud_run_service.simpletimeservice.status[0].url}"
  }
}

resource "google_api_gateway_gateway" "simpletimeservice_gateway" {
  name     = "simpletimeservice-gateway"
  region   = "us-central1"
  api      = google_api_gateway_api.simpletimeservice_api.id
  config   = google_api_gateway_api_config.simpletimeservice_api_config.id
}
