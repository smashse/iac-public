resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "template-default-vpc"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
