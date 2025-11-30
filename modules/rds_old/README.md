# Terraform RDS Module

Універсальний Terraform модуль для створення AWS RDS (Relational Database Service) з підтримкою як звичайних RDS instances, так і Aurora clusters.

## Особливості

- ✅ Підтримка Aurora Cluster та звичайних RDS instances
- ✅ Автоматичне створення DB Subnet Group
- ✅ Автоматичне створення Security Group
- ✅ Автоматичне створення Parameter Group з базовими налаштуваннями
- ✅ Підтримка PostgreSQL та MySQL
- ✅ Налаштування резервного копіювання
- ✅ Шифрування зберігання
- ✅ Multi-AZ розгортання
- ✅ Автоматичне масштабування Aurora

## Використання

### Приклад 1: Звичайна RDS Instance (PostgreSQL)

```hcl
module "rds" {
  source = "./modules/rds"

  # Основні налаштування
  use_aurora = false
  identifier = "my-postgres-db"
  
  # Двигун бази даних
  engine         = "postgres"
  engine_version = "14.9"
  instance_class = "db.t3.micro"
  
  # База даних
  database_name   = "myapp"
  master_username = "admin"
  master_password = "your-secure-password"
  
  # Мережа
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  # Додаткові налаштування
  multi_az = true
  storage_encrypted = true
  
  tags = {
    Environment = "Production"
    Project     = "MyApp"
  }
}
```

### Приклад 2: Aurora Cluster (PostgreSQL)

```hcl
module "rds" {
  source = "./modules/rds"

  # Основні налаштування
  use_aurora = true
  identifier = "my-aurora-cluster"
  
  # Двигун бази даних
  engine         = "aurora-postgresql"
  engine_version = "14.9"
  instance_class = "db.r6g.large"
  
  # База даних
  database_name   = "myapp"
  master_username = "admin"
  master_password = "your-secure-password"
  
  # Aurora налаштування
  aurora_cluster_size = 3  # 1 writer + 2 readers
  aurora_instance_class = "db.r6g.large"
  
  # Мережа
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  # Додаткові налаштування
  storage_encrypted = true
  
  tags = {
    Environment = "Production"
    Project     = "MyApp"
  }
}
```

### Приклад 3: MySQL RDS Instance

```hcl
module "rds" {
  source = "./modules/rds"

  # Основні налаштування
  use_aurora = false
  identifier = "my-mysql-db"
  
  # Двигун бази даних
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.micro"
  
  # База даних
  database_name   = "myapp"
  master_username = "admin"
  master_password = "your-secure-password"
  
  # Мережа
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  # Параметри бази даних
  max_connections = 200
  work_mem        = 8
  
  tags = {
    Environment = "Development"
    Project     = "MyApp"
  }
}
```

## Змінні

### Основні змінні

| Змінна | Тип | Опис | За замовчуванням |
|--------|-----|------|------------------|
| `use_aurora` | `bool` | Використовувати Aurora Cluster (true) або звичайну RDS instance (false) | `false` |
| `identifier` | `string` | Унікальний ідентифікатор для RDS instance або cluster | - |
| `engine` | `string` | Тип двигуна бази даних (mysql, postgres, aurora-mysql, aurora-postgresql) | `"postgres"` |
| `engine_version` | `string` | Версія двигуна бази даних | `"14.9"` |
| `instance_class` | `string` | Клас інстансу для RDS | `"db.t3.micro"` |
| `multi_az` | `bool` | Розгорнути в кількох зонах доступності | `false` |

### Змінні для бази даних

| Змінна | Тип | Опис | За замовчуванням |
|--------|-----|------|------------------|
| `database_name` | `string` | Назва бази даних для створення | `"mydb"` |
| `master_username` | `string` | Ім'я користувача адміністратора | `"admin"` |
| `master_password` | `string` | Пароль адміністратора | - |

### Змінні для мережі

| Змінна | Тип | Опис | За замовчуванням |
|--------|-----|------|------------------|
| `vpc_id` | `string` | ID VPC для розгортання RDS | - |
| `subnet_ids` | `list(string)` | Список ID підмереж для DB Subnet Group | - |
| `vpc_cidr_blocks` | `list(string)` | CIDR блоки VPC для Security Group | `["10.0.0.0/16"]` |

### Змінні для Aurora Cluster

| Змінна | Тип | Опис | За замовчуванням |
|--------|-----|------|------------------|
| `aurora_cluster_size` | `number` | Кількість інстансів в Aurora cluster | `1` |
| `aurora_instance_class` | `string` | Клас інстансу для Aurora reader instances | `"db.r6g.large"` |

### Змінні для параметрів бази даних

| Змінна | Тип | Опис | За замовчуванням |
|--------|-----|------|------------------|
| `max_connections` | `number` | Максимальна кількість підключень до бази даних | `100` |
| `log_statement` | `string` | Тип логування SQL запитів (none, ddl, mod, all) | `"none"` |
| `work_mem` | `number` | Робоча пам'ять для операцій сортування та хешування (в MB) | `4` |

### Змінні для резервного копіювання

| Змінна | Тип | Опис | За замовчуванням |
|--------|-----|------|------------------|
| `backup_retention_period` | `number` | Період зберігання резервних копій (в днях) | `7` |
| `backup_window` | `string` | Вікно для створення резервних копій (UTC) | `"03:00-04:00"` |
| `maintenance_window` | `string` | Вікно для технічного обслуговування (UTC) | `"sun:04:00-sun:05:00"` |

### Змінні для безпеки

| Змінна | Тип | Опис | За замовчуванням |
|--------|-----|------|------------------|
| `storage_encrypted` | `bool` | Шифрування зберігання даних | `true` |
| `deletion_protection` | `bool` | Захист від видалення | `false` |

### Змінні для тегів

| Змінна | Тип | Опис | За замовчуванням |
|--------|-----|------|------------------|
| `tags` | `map(string)` | Теги для ресурсів RDS | `{}` |

## Виводи

### Загальні виводи

| Вивід | Опис |
|-------|------|
| `database_name` | Назва бази даних |
| `master_username` | Ім'я користувача адміністратора |
| `engine` | Тип двигуна бази даних |
| `engine_version` | Версія двигуна бази даних |
| `connection_string` | Рядок підключення до бази даних (sensitive) |

### Виводи для DB Subnet Group

| Вивід | Опис |
|-------|------|
| `db_subnet_group_name` | Назва DB Subnet Group |
| `db_subnet_group_arn` | ARN DB Subnet Group |

### Виводи для Security Group

| Вивід | Опис |
|-------|------|
| `security_group_id` | ID Security Group для RDS |
| `security_group_name` | Назва Security Group для RDS |

### Виводи для Parameter Group

| Вивід | Опис |
|-------|------|
| `parameter_group_name` | Назва Parameter Group |
| `parameter_group_arn` | ARN Parameter Group |

### Виводи для Aurora Cluster (якщо use_aurora = true)

| Вивід | Опис |
|-------|------|
| `aurora_cluster_id` | ID Aurora Cluster |
| `aurora_cluster_endpoint` | Writer endpoint Aurora Cluster |
| `aurora_cluster_reader_endpoint` | Reader endpoint Aurora Cluster |
| `aurora_cluster_port` | Порт Aurora Cluster |
| `aurora_cluster_arn` | ARN Aurora Cluster |
| `aurora_writer_endpoint` | Endpoint Aurora Writer instance |
| `aurora_reader_endpoints` | Endpoints Aurora Reader instances |

### Виводи для RDS Instance (якщо use_aurora = false)

| Вивід | Опис |
|-------|------|
| `rds_instance_id` | ID RDS Instance |
| `rds_instance_endpoint` | Endpoint RDS Instance |
| `rds_instance_port` | Порт RDS Instance |
| `rds_instance_arn` | ARN RDS Instance |

## Як змінити тип БД

### PostgreSQL

```hcl
module "rds" {
  # ...
  engine         = "postgres"  # або "aurora-postgresql" для Aurora
  engine_version = "14.9"
  # ...
}
```

### MySQL

```hcl
module "rds" {
  # ...
  engine         = "mysql"  # або "aurora-mysql" для Aurora
  engine_version = "8.0.35"
  # ...
}
```

## Як змінити клас інстансу

### Для звичайної RDS

```hcl
module "rds" {
  # ...
  instance_class = "db.t3.micro"    # t3.micro для dev
  instance_class = "db.t3.small"    # t3.small для staging
  instance_class = "db.r6g.large"   # r6g.large для production
  # ...
}
```

### Для Aurora

```hcl
module "rds" {
  # ...
  use_aurora = true
  instance_class = "db.r6g.large"        # Writer instance
  aurora_instance_class = "db.r6g.large" # Reader instances
  # ...
}
```

## Як налаштувати Aurora Cluster

```hcl
module "rds" {
  # ...
  use_aurora = true
  aurora_cluster_size = 3  # 1 writer + 2 readers
  
  # Різні класи для writer та reader
  instance_class = "db.r6g.xlarge"        # Writer
  aurora_instance_class = "db.r6g.large"  # Readers
  # ...
}
```

## Як налаштувати параметри бази даних

```hcl
module "rds" {
  # ...
  max_connections = 200
  log_statement   = "mod"  # Логувати тільки зміни
  work_mem        = 8      # 8MB для операцій сортування
  # ...
}
```

## Як налаштувати безпеку

```hcl
module "rds" {
  # ...
  storage_encrypted = true
  deletion_protection = true
  
  # Обмежити доступ тільки до певних CIDR блоків
  vpc_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  # ...
}
```

## Як налаштувати резервне копіювання

```hcl
module "rds" {
  # ...
  backup_retention_period = 30  # Зберігати 30 днів
  backup_window          = "02:00-03:00"  # UTC
  maintenance_window     = "sun:03:00-sun:04:00"  # UTC
  # ...
}
```

## Примітки

1. **Пароль**: Змінна `master_password` має бути встановлена як sensitive
2. **Aurora**: Для Aurora використовуйте відповідні engine типи (`aurora-postgresql`, `aurora-mysql`)
3. **Multi-AZ**: Доступно тільки для звичайних RDS instances
4. **Security Group**: Автоматично дозволяє підключення з VPC на порти 5432 (PostgreSQL) та 3306 (MySQL)
5. **Parameter Group**: Автоматично створюється з базовими параметрами

## Требования

- Terraform >= 1.0
- AWS Provider >= 5.0
- VPC з приватними підмережами 