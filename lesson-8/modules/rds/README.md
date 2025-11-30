# Універсальний модуль RDS

Цей модуль забезпечує універсальне рішення для створення баз даних AWS RDS, підтримуючи як Aurora Cluster, так і звичайні RDS instances.

## Функціонал

### Основні можливості:
- **Aurora Cluster** (`use_aurora = true`) - створює Aurora Cluster з writer та reader instances
- **RDS Instance** (`use_aurora = false`) - створює звичайну RDS instance
- **Автоматичне створення**:
  - DB Subnet Group
  - Security Group з правилами для PostgreSQL (5432) та MySQL (3306)
  - Parameter Group з базовими параметрами

### Підтримувані двигуни:
- **PostgreSQL**: `postgres`, `aurora-postgresql`
- **MySQL**: `mysql`, `aurora-mysql`

## Структура модуля

```
modules/rds/
├── shared.tf      # Спільні ресурси (Subnet Group, Security Group, Parameter Group)
├── aurora.tf      # Aurora Cluster ресурси
├── rds.tf         # Звичайні RDS Instance ресурси
├── variables.tf   # Змінні модуля
├── outputs.tf     # Виводи модуля
└── README.md      # Документація
```

## Використання

### Aurora PostgreSQL Cluster

```hcl
module "aurora_postgres" {
  source = "./modules/rds"

  use_aurora = true
  identifier = "my-aurora-postgres"
  
  engine         = "aurora-postgresql"
  engine_version = "14.9"
  instance_class = "db.r6g.large"
  
  database_name   = "myapp"
  master_username = "admin"
  master_password = "secure-password"
  
  aurora_cluster_size = 3  # 1 writer + 2 readers
  aurora_instance_class = "db.r6g.large"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  storage_encrypted = true
  backup_retention_period = 30
  
  tags = {
    Environment = "Production"
    Project     = "MyApp"
  }
}
```

### Aurora MySQL Cluster

```hcl
module "aurora_mysql" {
  source = "./modules/rds"

  use_aurora = true
  identifier = "my-aurora-mysql"
  
  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.05.1"
  instance_class = "db.r6g.large"
  
  database_name   = "myapp"
  master_username = "admin"
  master_password = "secure-password"
  
  aurora_cluster_size = 2  # 1 writer + 1 reader
  aurora_instance_class = "db.r6g.large"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  storage_encrypted = true
  backup_retention_period = 30
  
  tags = {
    Environment = "Production"
    Project     = "MyApp"
  }
}
```

### PostgreSQL RDS Instance

```hcl
module "postgres_rds" {
  source = "./modules/rds"

  use_aurora = false
  identifier = "my-postgres-rds"
  
  engine         = "postgres"
  engine_version = "14.9"
  instance_class = "db.t3.micro"
  
  database_name   = "myapp"
  master_username = "admin"
  master_password = "secure-password"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  multi_az = false
  storage_encrypted = true
  backup_retention_period = 7
  
  tags = {
    Environment = "Development"
    Project     = "MyApp"
  }
}
```

### MySQL RDS Instance

```hcl
module "mysql_rds" {
  source = "./modules/rds"

  use_aurora = false
  identifier = "my-mysql-rds"
  
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.micro"
  
  database_name   = "myapp"
  master_username = "admin"
  master_password = "secure-password"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  multi_az = true
  storage_encrypted = true
  backup_retention_period = 7
  
  tags = {
    Environment = "Production"
    Project     = "MyApp"
  }
}
```

## Змінні

### Обов'язкові змінні:
- `identifier` (string, required) - Унікальний ідентифікатор для RDS instance або cluster
- `master_password` (string, required, sensitive) - Пароль адміністратора
- `vpc_id` (string, required) - ID VPC для розгортання RDS
- `subnet_ids` (list(string), required) - Список ID підмереж для DB Subnet Group

### Основні змінні:
- `use_aurora` (bool, default: `false`) - Використовувати Aurora Cluster (true) або звичайну RDS instance (false)
- `engine` (string, default: `"postgres"`) - Тип двигуна бази даних:
  - Для Aurora: `"aurora-postgresql"`, `"aurora-mysql"`
  - Для RDS: `"postgres"`, `"mysql"`
- `engine_version` (string, default: `"14.9"`) - Версія двигуна бази даних
  - PostgreSQL: `"14.9"`, `"15.4"`, `"16.1"`
  - MySQL: `"8.0.35"`, `"8.0.33"`
  - Aurora PostgreSQL: `"14.9"`, `"15.4"`
  - Aurora MySQL: `"8.0.mysql_aurora.3.05.1"`
- `instance_class` (string, default: `"db.t3.micro"`) - Клас інстансу для RDS або Aurora writer:
  - RDS: `"db.t3.micro"`, `"db.t3.small"`, `"db.t3.medium"`, `"db.r6g.large"`
  - Aurora: `"db.r6g.large"`, `"db.r6g.xlarge"`, `"db.r6g.2xlarge"`
- `database_name` (string, default: `"mydb"`) - Назва бази даних для створення
- `master_username` (string, default: `"admin"`) - Ім'я користувача адміністратора

### Aurora змінні (якщо use_aurora = true):
- `aurora_cluster_size` (number, default: `1`) - Кількість інстансів в Aurora cluster (мінімум 1 для writer)
- `aurora_instance_class` (string, default: `"db.r6g.large"`) - Клас інстансу для Aurora reader instances

### RDS змінні (якщо use_aurora = false):
- `multi_az` (bool, default: `false`) - Розгорнути в кількох зонах доступності (висока доступність)

### Параметри бази даних:
- `max_connections` (number, default: `100`) - Максимальна кількість підключень до бази даних
- `log_statement` (string, default: `"none"`) - Тип логування SQL запитів:
  - `"none"` - не логувати
  - `"ddl"` - логувати DDL команди
  - `"mod"` - логувати модифікації даних
  - `"all"` - логувати всі запити
- `work_mem` (number, default: `4`) - Робоча пам'ять для операцій сортування та хешування (в MB)

### Резервне копіювання:
- `backup_retention_period` (number, default: `7`) - Період зберігання резервних копій (в днях, 0-35)
- `backup_window` (string, default: `"03:00-04:00"`) - Вікно для створення резервних копій (UTC формат: `"HH:MM-HH:MM"`)
- `maintenance_window` (string, default: `"sun:04:00-sun:05:00"`) - Вікно для технічного обслуговування (UTC формат: `"ddd:HH:MM-ddd:HH:MM"`)

### Безпека:
- `storage_encrypted` (bool, default: `true`) - Шифрування зберігання даних
- `deletion_protection` (bool, default: `false`) - Захист від видалення
- `vpc_cidr_blocks` (list(string), default: `["10.0.0.0/16"]`) - CIDR блоки VPC для Security Group

### Теги:
- `tags` (map(string), default: `{}`) - Теги для ресурсів RDS

## Як змінити тип БД, engine, клас інстансу

### Зміна типу БД (Aurora ↔ RDS)

Щоб перейти з RDS на Aurora:
```hcl
module "rds" {
  source = "./modules/rds"
  
  use_aurora = true  # Змінити з false на true
  
  # Для Aurora потрібно використовувати aurora- префікс
  engine = "aurora-postgresql"  # або "aurora-mysql"
  
  # Решта параметрів залишаються
  identifier = "my-db"
  # ...
}
```

Щоб перейти з Aurora на RDS:
```hcl
module "rds" {
  source = "./modules/rds"
  
  use_aurora = false  # Змінити з true на false
  
  # Для RDS прибрати aurora- префікс
  engine = "postgres"  # або "mysql"
  
  # Решта параметрів залишаються
  identifier = "my-db"
  # ...
}
```

**Увага**: Зміна типу БД потребує створення нового ресурсу. Terraform не може міграцію між Aurora та RDS автоматично.

### Зміна engine (PostgreSQL ↔ MySQL)

```hcl
module "rds" {
  source = "./modules/rds"
  
  # Для PostgreSQL
  engine = "postgres"  # або "aurora-postgresql" для Aurora
  engine_version = "14.9"
  
  # Або для MySQL
  engine = "mysql"  # або "aurora-mysql" для Aurora
  engine_version = "8.0.35"
  
  # Решта параметрів
  identifier = "my-db"
  # ...
}
```

**Увага**: Зміна engine також потребує створення нового ресурсу.

### Зміна класу інстансу

```hcl
module "rds" {
  source = "./modules/rds"
  
  # Для RDS
  instance_class = "db.t3.micro"    # Мінімальний
  instance_class = "db.t3.small"    # Маленький
  instance_class = "db.t3.medium"   # Середній
  instance_class = "db.r6g.large"   # Великий з оптимізацією пам'яті
  
  # Для Aurora writer
  instance_class = "db.r6g.large"
  
  # Для Aurora readers (окрема змінна)
  aurora_instance_class = "db.r6g.xlarge"
  
  # Решта параметрів
  identifier = "my-db"
  # ...
}
```

**Примітка**: Зміна класу інстансу може бути виконана без створення нового ресурсу, але потребує перезапуску інстансу.

### Зміна версії engine

```hcl
module "rds" {
  source = "./modules/rds"
  
  engine = "postgres"
  engine_version = "14.9"  # Змінити на "15.4" або "16.1"
  
  # Решта параметрів
  identifier = "my-db"
  # ...
}
```

**Примітка**: Оновлення версії engine може бути виконано через мінорні оновлення без створення нового ресурсу.

### Зміна кількості інстансів Aurora

```hcl
module "rds" {
  source = "./modules/rds"
  
  use_aurora = true
  aurora_cluster_size = 3  # 1 writer + 2 readers
  
  # Решта параметрів
  identifier = "my-db"
  # ...
}
```

**Примітка**: Зміна кількості reader instances може бути виконана без створення нового кластера.

## Виводи

### Спільні виводи:
- `database_name` - Назва бази даних
- `master_username` - Ім'я користувача адміністратора
- `engine` - Тип двигуна бази даних
- `engine_version` - Версія двигуна бази даних

### Aurora виводи (якщо use_aurora = true):
- `aurora_cluster_id` - ID Aurora Cluster
- `aurora_cluster_endpoint` - Writer endpoint Aurora Cluster
- `aurora_cluster_reader_endpoint` - Reader endpoint Aurora Cluster
- `aurora_cluster_port` - Порт Aurora Cluster
- `aurora_writer_endpoint` - Endpoint Aurora Writer instance
- `aurora_reader_endpoints` - Endpoints Aurora Reader instances

### RDS виводи (якщо use_aurora = false):
- `rds_instance_id` - ID RDS Instance
- `rds_instance_endpoint` - Endpoint RDS Instance
- `rds_instance_port` - Порт RDS Instance

### Спільні ресурси:
- `db_subnet_group_name` - Назва DB Subnet Group
- `security_group_id` - ID Security Group для RDS
- `parameter_group_name` - Назва Parameter Group

### Connection string:
- `connection_string` - Рядок підключення до бази даних (sensitive)

## Використання в main.tf

### Базовий приклад

```hcl
# В main.tf
module "rds" {
  source = "./modules/rds"

  # Обов'язкові параметри
  identifier     = "lesson-8-db"
  master_password = "your-secure-password-here"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_ids

  # Тип БД (false = RDS, true = Aurora)
  use_aurora = false

  # Двигун та версія
  engine         = "postgres"
  engine_version = "14.9"
  instance_class = "db.t3.micro"

  # База даних
  database_name   = "django_app"
  master_username = "admin"

  # Додаткові налаштування
  multi_az          = false
  storage_encrypted = true
  backup_retention_period = 7

  tags = {
    Environment = "Production"
    Project     = "Lesson-8"
  }
}
```

### Приклад з Aurora

```hcl
# В main.tf
module "rds" {
  source = "./modules/rds"

  # Обов'язкові параметри
  identifier     = "lesson-8-aurora"
  master_password = "your-secure-password-here"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_ids

  # Тип БД - Aurora
  use_aurora = true

  # Aurora двигун
  engine         = "aurora-postgresql"
  engine_version = "14.9"
  instance_class = "db.r6g.large"

  # База даних
  database_name   = "django_app"
  master_username = "admin"

  # Aurora налаштування
  aurora_cluster_size = 2  # 1 writer + 1 reader
  aurora_instance_class = "db.r6g.large"

  # Додаткові налаштування
  storage_encrypted = true
  backup_retention_period = 30

  tags = {
    Environment = "Production"
    Project     = "Lesson-8"
  }
}
```

## Приклади

Дивіться папку `examples/` для детальних прикладів використання:
- `aurora-example.tf` - Aurora PostgreSQL Cluster
- `aurora-mysql-example.tf` - Aurora MySQL Cluster
- `postgres-example.tf` - PostgreSQL RDS Instance
- `mysql-example.tf` - MySQL RDS Instance

## Безпека

Модуль автоматично створює Security Group з правилами для:
- PostgreSQL (порт 5432)
- MySQL (порт 3306)
- Вихідний трафік

Рекомендується:
- Використовувати сильні паролі
- Увімкнути шифрування зберігання
- Налаштувати резервне копіювання
- Використовувати приватні підмережі

## Вимоги

- Terraform >= 1.0
- AWS Provider >= 4.0
- VPC з приватними підмережами
- Доступ до AWS RDS сервісів 