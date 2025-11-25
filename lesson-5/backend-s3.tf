terraform {
  backend "s3" {
    bucket         = "andrii-stanislav-terraform-backend"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
} 