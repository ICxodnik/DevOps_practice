# Локальний backend для першого запуску (розкоментуйте для першого запуску)
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# S3 backend (розкоментуйте після створення S3 бакета та закоментуйте локальний)
# terraform {
#   backend "s3" {
#     bucket         = "nataliia-khodorova-terraform-backend"
#     key            = "lesson-5/terraform.tfstate"
#     region         = "us-west-2"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }
