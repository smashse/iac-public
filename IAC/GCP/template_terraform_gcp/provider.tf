# Default Provider for GCP
provider "google" {
  project     = var.gcp_project
  credentials = var.gcp_profile
  region      = var.gcp_region
  zone        = var.gcp_zone_id[var.gcp_region]
}
