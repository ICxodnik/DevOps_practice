# Налаштування бекенду для стейт-файлів (S3 + DynamoDB)
terraform {
  backend "s3" {
    bucket         = "nataliia-khodorova-terraform-backend"
    key            = "lesson-7/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
} 