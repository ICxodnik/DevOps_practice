variable "ecr_name" {
  description = "Ім'я ECR репозиторію"
  type        = string
}

variable "scan_on_push" {
  description = "Увімкнути автоматичне сканування образів при пуші"
  type        = bool
  default     = true
}

variable "image_tag_mutability" {
  description = "Тип мутабельності тегів образів"
  type        = string
  default     = "MUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability повинен бути MUTABLE або IMMUTABLE."
  }
} 