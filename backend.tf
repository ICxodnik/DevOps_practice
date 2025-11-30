# Backend конфігурація
# Для production використовуйте S3 backend:
# terraform {
#   backend "s3" {
#     bucket = "nataliia-khodorova-terraform-backend"
#     key    = "terraform.tfstate"
#     region = "us-west-2"
#     dynamodb_table = "terraform-locks"
#   }
# }

# Локальний backend для розробки
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
} 
