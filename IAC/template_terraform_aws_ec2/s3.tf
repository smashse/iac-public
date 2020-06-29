# S3 Bucket
resource "aws_s3_bucket" "tfstate_template" {
  bucket        = "tfstate-template"
  acl           = "private"
  force_destroy = true
  versioning {
    enabled = false
  }
  lifecycle {
    prevent_destroy = false
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# S3 Bucket Object
resource "aws_s3_bucket_object" "terraform" {
  bucket = aws_s3_bucket.tfstate_template.id
  acl    = "private"
  key    = "terraform/vpc/"
  source = "/dev/null"
}
