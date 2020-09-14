variable "gcp_project" {
  type        = string
  description = "GCP project used for all resources"
  default     = "template-terraform-project"
}

variable "gcp_profile" {
  type        = string
  description = "GCP profile used for all resources"
  default     = "~/.config/gcloud/template-account.json"
}

variable "gcp_region" {
  type        = string
  description = "GCP region used for all resources"
  default     = "southamerica-east1"
}

variable "gcp_zone_id" {
  type        = map
  description = "Availability zone name used for all GCP instances"
  default = {
    "us-central1"        = "us-central1-a"
    "southamerica-east1" = "southamerica-east1-a"
  }
}

variable "gcp_image_id" {
  type        = map
  description = "Image used for all GCP instances"
  default = {
    "cos"    = "cos-cloud/cos-81-lts"
    "centos" = "centos-cloud/centos-8"
    "debian" = "debian-cloud/debian-10"
    "ubuntu" = "ubuntu-os-cloud/ubuntu-2004-lts"
  }
}

variable "gcp_machine_type_id" {
  type        = map
  description = "Instance type used for all Bundle instances"
  default = {
    "n1micro"  = "f1-micro"  #1vCPU 0.6GB RAM
    "n1small"  = "g1-small"  #1vCPU 1.7GB RAM
    "e2micro"  = "e2-micro"  #2vCPU 1.0GB RAM
    "e2small"  = "e2-small"  #2vCPU 2.0GB RAM
    "e2medium" = "e2-medium" #2vCPU 4.0GB RAM
  }
}

variable "gcp_cargo_count" {
  type        = string
  description = "Instance count for Cargo instances"
  default     = "3"
}

variable "gcp_ssh_key" {
  type        = string
  description = "Username and SSH private key used for instances"
  default     = "./ssh_key/template-access.pub"
}
