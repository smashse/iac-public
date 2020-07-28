resource "google_compute_firewall" "template_default_firewall" {
  name    = "template-default-firewall"
  network = google_compute_network.template_default_vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8080", "1000-2000"]
  }

  source_tags   = ["ssh", "web"]
  source_ranges = ["0.0.0.0/0"]
}
