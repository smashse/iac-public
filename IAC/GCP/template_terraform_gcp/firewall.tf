resource "google_compute_firewall" "microk8s_default_firewall" {
  name    = "microk8s-default-firewall"
  network = google_compute_network.microk8s_default_vpc.name

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
