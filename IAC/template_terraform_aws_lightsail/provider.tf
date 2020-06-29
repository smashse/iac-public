# Default Provider for AWS
provider "aws" {
  version                 = "~> 2.55"
  profile                 = var.aws_profile
  shared_credentials_file = "~/.aws/credentials"
  region                  = var.aws_region
}
