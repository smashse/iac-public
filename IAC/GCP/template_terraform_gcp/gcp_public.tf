resource "google_compute_instance" "template_instance" {
  name         = "template-instance"
  machine_type = var.gcp_machine_type_id.n1micro

  boot_disk {
    initialize_params {
      image = var.gcp_image_id.ubuntu
    }
  }

  network_interface {
    network = google_compute_network.template_default_vpc.self_link
    access_config {
    }
  }

}
