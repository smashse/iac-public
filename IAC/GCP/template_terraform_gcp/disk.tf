resource "google_compute_disk" "template_instance_disk" {
  name  = "template-instance-disk"
  type  = "pd-ssd"
  zone  = var.gcp_zone_id[var.gcp_region]
  image = var.gcp_image_id.ubuntu
  size  = 10
  labels = {
    environment = "template"
  }
  physical_block_size_bytes = 4096
}