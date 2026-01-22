# DynamoDB

resource "aws_dynamodb_table" "state_lock" {

  name         = "vpc-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {

    name = "LockID"
    type = "S"

  }

  lifecycle {

    prevent_destroy = true

  }

}
