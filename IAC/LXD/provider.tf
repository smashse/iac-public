provider "lxd" {
  generate_client_certificates = true
  accept_remote_certificate    = true

  lxd_remote {
    name     = "mobile"
    scheme   = "https"
    address  = "127.0.0.1"
    port     = "8443"
    password = "mobile"
    default  = true
  }
}
