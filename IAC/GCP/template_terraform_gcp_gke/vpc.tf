# Default Provider for GCP
provider "google" {
  project     = var.gcp_project
  credentials = var.gcp_profile
  region      = var.gcp_region
  zone        = var.gcp_zone_id[var.gcp_region]
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.gcp_project}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.gcp_project}-subnet"
  region        = var.gcp_region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"

}

output "region" {
  value       = var.gcp_region
  description = "region"
}
