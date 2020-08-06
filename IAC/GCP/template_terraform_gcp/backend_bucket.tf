resource "google_storage_bucket" "template_terraform" {
  name          = "template-terraform"
  location      = "EU"
  force_destroy = true
  versioning {
    enabled = false
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "google_compute_backend_bucket" "template_tfstate" {
  name        = "template-tfstate"
  bucket_name = google_storage_bucket.template_terraform.name
  enable_cdn  = true
}
