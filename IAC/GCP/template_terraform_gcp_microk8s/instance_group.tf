resource "google_compute_instance_group" "template_default_ig" {
  name        = "template-default-ig"
  description = "GCP template default ig"

  instances = [
    google_compute_instance.control_instance.id,
    #google_compute_instance.cargo_instance,
  ]

  named_port {
    name = "ssh"
    port = "22"
  }

  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "https"
    port = "443"
  }

  named_port {
    name = "dashboard"
    port = "10443"
  }

  named_port {
    name = "microk8s"
    port = "25000"
  }

  zone = var.gcp_zone_id[var.gcp_region]
}
