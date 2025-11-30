variable "cluster_name" {
  description = "Ім'я EKS кластера"
  type        = string
}

variable "cluster_version" {
  description = "Версія Kubernetes"
  type        = string
  default     = "1.28"
}

variable "vpc_id" {
  description = "ID VPC для кластера"
  type        = string
}

variable "private_subnet_ids" {
  description = "ID приватних підмереж для кластера"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "ID публічних підмереж для кластера"
  type        = list(string)
}

variable "node_group_name" {
  description = "Ім'я групи вузлів"
  type        = string
  default     = "main-node-group"
}

variable "node_group_instance_types" {
  description = "Типи інстансів для групи вузлів"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_desired_size" {
  description = "Бажана кількість вузлів"
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Максимальна кількість вузлів"
  type        = number
  default     = 4
}

variable "node_group_min_size" {
  description = "Мінімальна кількість вузлів"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Теги для ресурсів"
  type        = map(string)
  default     = {}
} 