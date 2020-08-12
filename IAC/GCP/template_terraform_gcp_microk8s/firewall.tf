resource "google_compute_firewall" "template_default_firewall" {
  name    = "template-default-firewall"
  network = google_compute_network.template_default_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "sctp"
    ports    = ["0-65535"]
  }

  source_ranges = ["0.0.0.0/0", "10.158.0.0/20"]
}
