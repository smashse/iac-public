resource "google_compute_instance" "template_instance" {
  name         = "template-instance"
  machine_type = var.gcp_machine_type_id.n1micro

  boot_disk {
    initialize_params {
      image = var.gcp_image_id.ubuntu
    }
  }

  metadata = {
    user-data = file("./cloud_init/ubuntu-generic-clean.yml")
  }

  network_interface {
    network = google_compute_network.template_default_vpc.self_link
    access_config {
    }
  }

}
