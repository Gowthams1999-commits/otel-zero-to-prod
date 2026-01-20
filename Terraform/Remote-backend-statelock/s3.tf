# random id generation for bucket suffix
resource "random_id" "bucket-suffix" {

  byte_length = 8

}



locals {

  common_tags = {


    managed_by = "terraform"
    project    = "otel"

  }
}


# Create s3 bucket
resource "aws_s3_bucket" "remote_backend_bucket" {


  bucket = "remote-backend-${random_id.bucket-suffix.hex}"

  lifecycle {


    prevent_destroy = true

  }
}


# Enable bucket versioning
resource "aws_s3_bucket_versioning" "versioning_enabled" {


  bucket = aws_s3_bucket.remote_backend_bucket.id
  versioning_configuration {

    status = "Enabled"

  }

}

# Apply server side encryption for s3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {


  bucket = aws_s3_bucket.remote_backend_bucket.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"

    }
  }
}
