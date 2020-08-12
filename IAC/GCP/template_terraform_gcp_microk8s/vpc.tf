resource "google_compute_network" "template_default_vpc" {
  name                    = "template-default-vpc"
  auto_create_subnetworks = "true"
}
