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

variable "aws_blueprint_id" {
  type        = map
  description = "OS used for Blueprint IDs"
  default = {
    "amazon" = "amazon_linux_2018_03_0_2"
    "centos" = "centos_7_1901_01"
    "debian" = "debian_9_5"
    "ubuntu" = "buntu_18_04"
  }
}

variable "aws_bundle_id" {
  type        = map
  description = "Instance type used for all Bundle instances"
  default = {
    "nano"    = "nano_2_0"
    "micro"   = "micro_2_0"
    "small"   = "small_2_0"
    "medium"  = "medium_2_0"
    "large"   = "large_2_0"
    "xlarge"  = "xlarge_2_0"
    "2xlarge" = "2xlarge_2_0"
  }
}

variable "ssh_key_pair_name" {
  type        = string
  description = "Key pair name of SSH private key used for infrastructure and RKE"
  default     = "template-access"
}
