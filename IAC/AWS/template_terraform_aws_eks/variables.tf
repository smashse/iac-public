variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile used for all resources"
  default     = "template"
}

variable "aws_zone_id" {
  type        = map
  description = "Availability zone name used for all EC2 instances"
  default = {
    "us-east-1" = "us-east-1a"
    "us-east-2" = "us-east-2a"
  }
}

variable "ssh_key_file_name" {
  type        = string
  description = "File path and name of SSH private key used for infrastructure and RKE"
  default     = "~/.ssh/id_rsa"
}

variable "ssh_key_pair_name" {
  type        = string
  description = "Key pair name of SSH private key used for infrastructure and RKE"
  default     = "template-access"
}

variable "aws_certificate_arn" {
  type        = string
  description = "ARN for you Certificate Issued by Amazon"
  default     = ""
}

variable "manage_default_network_acl" {
  type        = bool
  description = "Should be true to adopt and manage Default Network ACL"
  default     = true
}
