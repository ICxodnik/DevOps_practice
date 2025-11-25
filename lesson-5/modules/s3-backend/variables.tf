variable "bucket_name" {
  description = "Ім'я S3 бакета для стейт-файлів Terraform"
  type        = string
}

variable "table_name" {
  description = "Ім'я DynamoDB таблиці для блокування стейтів"
  type        = string
  default     = "terraform-locks"
} 