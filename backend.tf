# Тимчасовий локальний бекенд для ініціалізації
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
} 