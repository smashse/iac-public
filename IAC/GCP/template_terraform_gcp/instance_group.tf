resource "google_compute_instance_group" "template_default_ig" {
  name = "template-default-ig"
  zone = var.gcp_zone_id[var.gcp_region]
  instances = [
    google_compute_instance.template_instance.self_link,
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

  lifecycle {
    create_before_destroy = true
  }

}
