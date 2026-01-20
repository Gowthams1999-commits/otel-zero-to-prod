terraform {
  backend "s3" {
    bucket         = ""
    key            = "project-name/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "state-lock"
    encrypt        = true
  }
}
