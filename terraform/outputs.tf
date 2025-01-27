
# Output the URL of the Cloud Run service
output "cloud_run_url" {
  value = google_cloud_run_service.simpletimeservice.status[0].url
}

