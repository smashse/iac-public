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
    "n1micro"      = "f1-micro"       #1vCPU 0.6GB RAM
    "n1small"      = "g1-small"       #1vCPU 1.7GB RAM
    "e2micro"      = "e2-micro"       #2vCPU 1.0GB RAM
    "e2small"      = "e2-small"       #2vCPU 2.0GB RAM
    "e2medium"     = "e2-medium"      #2vCPU 4.0GB RAM
    "n1standard1"  = "n1-standard-1"  #1vCPU 3.75GB RAM
    "n1standard2"  = "n1-standard-2"  #2vCPU 7.5GB RAM
    "n1standard4"  = "n1-standard-4"  #4vCPU 15GB RAM
    "n1standard8"  = "n1-standard-8"  #8vCPU 30GB RAM
    "n1standard16" = "n1-standard-16" #16vCPU 60GB RAM
    "n1standard32" = "n1-standard-32" #32vCPU 120GB RAM
    "n1standard64" = "n1-standard-64" #64vCPU 240GB RAM
    "n1standard96" = "n1-standard-96" #96vCPU 360GB RAM
  }
}

variable "gcp_ssh_key" {
  type        = string
  description = "Username and SSH private key used for instances"
  default     = "./ssh_key/template-access.pub"
}
