# Simple Time Service on Google Cloud Run

This repository contains a simple Python Flask application that returns the current timestamp and the IP address of the requesting user. The app is containerized using Docker and deployed on Google Cloud Run.

## Prerequisites
Before you begin, make sure you have the following tools and accounts set up:
- Google Cloud Platform (GCP) account with a project created.
- Docker installed on your local machine.
- Terraform installed on your local machine.
- A Google Cloud Service Account with the following roles:
  - Cloud Run Admin
  - Viewer
  - IAM Service Account User
  - IAM Policy Administrator
- Service Account JSON key for Terraform to authenticate with GCP.

## ACCESS APP LOCALLY:
## Step 1: Clone the Repository
Clone this repository to your local machine:
 ```
git clone https://github.com/Dev2108/SimpleTimeService.git
cd simple-time-service
```

## Step 2: Build the image and run the  container
```
cd app
docker build -t simple-time-service:latest .
docker run -p 8080:8080 simple-time-service:latest
```

## Step 3: Access app locally
After running the container, you should see output similar to this in your terminal:
```
* Serving Flask app "app" (lazy loading)
* Environment: production
* Debug mode: on
* Running on http://0.0.0.0:8080/ (Press CTRL+C to quit)
```
Now, open your browser and go to:
```
http://localhost:8080/
```
You should see the output of the app in JSON format, showing the current timestamp and the IP address of the requester.
```
{
  "timestamp": "2025-01-27 15:25:30",
  "ip": "127.0.0.1"
}
```

## RUN APP ON GCP CLOUD RUN AND ACCESS IT VIA CLOUD RUN SERVICE URL:

## Step 1: Update terraform.tfvars file, add your gcp project id and the json key of service account which you have created during prerequisite step:
```
gcp_project_id        = "your-gcp-project-id"
gcp_credentials_file  = "path/to/your/service-account-key.json"
```
## Step 2: Initialize Terraform, then plan and apply:
```
terraform init
terraform plan
terraform apply
```
## Step 3: Access Your Cloud Run Service
Once the Terraform deployment is complete, you will see the URL of your Cloud Run service as output:
```
Outputs:

cloud_run_url = https://your-service-url.a.run.app
```

## Directory Structure
```
simple-time-service/
├── app.py                 # Python Flask app
├── Dockerfile             # Dockerfile to build the container
├── requirements.txt       # Python dependencies
├── terraform/             # Terraform files for GCP infrastructure
│   ├── cloud_run_service.tf
│   ├── network.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── terraform.tfvars
└── README.md              # This file
```

Thank you for using the Simple Time Service! By following the steps outlined in this guide, you should now have a working Flask app deployed on Google Cloud Run, containerized with Docker. This service can easily be customized or expanded to fit your needs.

If you have any issues or feedback, feel free to open an issue in the repository or reach out. Happy coding, and enjoy building with Cloud Run!



