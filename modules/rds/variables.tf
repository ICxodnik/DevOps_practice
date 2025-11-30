# Основні змінні для RDS модуля
variable "use_aurora" {
  description = "Використовувати Aurora Cluster (true) або звичайну RDS instance (false)"
  type        = bool
  default     = false
}

variable "identifier" {
  description = "Унікальний ідентифікатор для RDS instance або cluster"
  type        = string
}

variable "engine" {
  description = "Тип двигуна бази даних (mysql, postgres, aurora-mysql, aurora-postgresql)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Версія двигуна бази даних"
  type        = string
  default     = "14.9"
}

variable "instance_class" {
  description = "Клас інстансу для RDS (для Aurora використовується тільки для writer)"
  type        = string
  default     = "db.t3.micro"
}

variable "multi_az" {
  description = "Розгорнути в кількох зонах доступності"
  type        = bool
  default     = false
}

# Змінні для бази даних
variable "database_name" {
  description = "Назва бази даних для створення"
  type        = string
  default     = "mydb"
}

variable "master_username" {
  description = "Ім'я користувача адміністратора"
  type        = string
  default     = "admin"
}

variable "master_password" {
  description = "Пароль адміністратора"
  type        = string
  sensitive   = true
}

# Змінні для мережі
variable "vpc_id" {
  description = "ID VPC для розгортання RDS"
  type        = string
}

variable "subnet_ids" {
  description = "Список ID підмереж для DB Subnet Group"
  type        = list(string)
}

variable "vpc_cidr_blocks" {
  description = "CIDR блоки VPC для Security Group"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

# Змінні для Aurora Cluster
variable "aurora_cluster_size" {
  description = "Кількість інстансів в Aurora cluster (мінімум 1 для writer)"
  type        = number
  default     = 1
}

variable "aurora_instance_class" {
  description = "Клас інстансу для Aurora reader instances"
  type        = string
  default     = "db.r6g.large"
}

# Змінні для параметрів бази даних
variable "max_connections" {
  description = "Максимальна кількість підключень до бази даних"
  type        = number
  default     = 100
}

variable "log_statement" {
  description = "Тип логування SQL запитів (none, ddl, mod, all)"
  type        = string
  default     = "none"
}

variable "work_mem" {
  description = "Робоча пам'ять для операцій сортування та хешування (в MB)"
  type        = number
  default     = 4
}

# Змінні для резервного копіювання
variable "backup_retention_period" {
  description = "Період зберігання резервних копій (в днях)"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Вікно для створення резервних копій (UTC)"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Вікно для технічного обслуговування (UTC)"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

# Змінні для шифрування
variable "storage_encrypted" {
  description = "Шифрування зберігання даних"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Захист від видалення"
  type        = bool
  default     = false
}

# Змінні для тегів
variable "tags" {
  description = "Теги для ресурсів RDS"
  type        = map(string)
  default     = {}
} 