# Lesson-7: Kubernetes на AWS з Django застосунком

Цей проєкт демонструє створення повної інфраструктури на AWS з використанням Terraform, включаючи EKS кластер, ECR репозиторій та розгортання Django застосунку через Helm.

## Структура проєкту

```
lesson-7/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf               # Загальні виводи ресурсів
│
├── modules/                 # Каталог з усіма модулями
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   ├── vpc/                 # Модуль для VPC
│   ├── ecr/                 # Модуль для ECR
│   └── eks/                 # Модуль для Kubernetes кластера
│
├── django-app/              # Django застосунок
│   ├── travel_project/           # Django проект
│   ├── travel_tracker/               # Django додаток
│   ├── Dockerfile           # Docker образ
│   ├── requirements.txt     # Python залежності
│   └── env.example          # Приклад змінних середовища
│
├── charts/                  # Helm чарти
│   └── django-app/
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   ├── hpa.yaml
│       │   └── _helpers.tpl
│       ├── Chart.yaml
│       └── values.yaml
│
├── scripts/                 # Скрипти для автоматизації
│   ├── build-and-push.sh    # Збірка та завантаження Docker образу
│   ├── deploy.sh            # Розгортання через Helm
│   └── setup-kubectl.sh     # Налаштування kubectl
│
└── README.md                # Документація проєкту
```

## Компоненти інфраструктури

### 1. VPC та мережева інфраструктура

- **VPC**: Віртуальна приватна хмара з CIDR блоком 10.0.0.0/16
- **Публічні підмережі**: 3 підмережі з автоматичним призначенням публічних IP
- **Приватні підмережі**: 3 підмережі для EKS кластера
- **Internet Gateway**: Для доступу публічних підмереж до інтернету
- **NAT Gateway**: Для доступу приватних підмереж до інтернету

### 2. EKS кластер

- **Kubernetes версія**: 1.28
- **Тип вузлів**: t3.medium
- **Кількість вузлів**: 2-4 (автоматичне масштабування)
- **Розташування**: Приватні підмережі

### 3. ECR репозиторій

- **Назва**: lesson-7-ecr
- **Автоматичне сканування**: Увімкнено
- **Політика життєвого циклу**: Автоматичне очищення старих образів

### 4. Django застосунок

- **Версія Django**: 4.2.7
- **WSGI сервер**: Gunicorn
- **Health check**: /health/ endpoint
- **Статичні файли**: Обробка через WhiteNoise

### 5. Helm чарт

- **Deployment**: З health checks та ресурсними лімітами
- **Service**: LoadBalancer тип для зовнішнього доступу
- **HPA**: Автоматичне масштабування від 2 до 6 подів
- **ConfigMap**: Змінні середовища для Django

## Передумови

1. **Terraform**: Версія >= 1.0
2. **AWS CLI**: Налаштований з відповідними credentials
3. **kubectl**: Для роботи з Kubernetes
4. **Helm**: Для розгортання чартів
5. **Docker**: Для збірки образів
6. **AWS Account**: З необхідними правами

## Кроки виконання

### 1. Створення інфраструктури

```bash
cd lesson-7

# Ініціалізація Terraform
terraform init

# Перегляд плану
terraform plan

# Застосування змін
terraform apply
```

### 2. Налаштування kubectl

```bash
# Налаштування kubectl для роботи з кластером
chmod +x scripts/setup-kubectl.sh
./scripts/setup-kubectl.sh
```

### 3. Збірка та завантаження Docker образу

```bash
# Збірка та завантаження образу в ECR
chmod +x scripts/build-and-push.sh
./scripts/build-and-push.sh
```

### 4. Розгортання застосунку

```bash
# Розгортання через Helm
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

## Перевірка роботи

### Перевірка подів

```bash
kubectl get pods -l app.kubernetes.io/name=django-app
```

### Перевірка сервісів

```bash
kubectl get svc django-app
```

### Перевірка HPA

```bash
kubectl get hpa django-app
```

### Отримання URL застосунку

```bash
kubectl get svc django-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

### Перевірка логів

```bash
kubectl logs -l app.kubernetes.io/name=django-app
```

## Змінні середовища

Django застосунок використовує наступні змінні середовища (через ConfigMap):

- `DEBUG`: Режим налагодження (False для production)
- `SECRET_KEY`: Секретний ключ Django
- `ALLOWED_HOSTS`: Дозволені хости
- `STATIC_URL`: URL для статичних файлів
- `STATIC_ROOT`: Шлях до статичних файлів
- `LOG_LEVEL`: Рівень логування
- `ENVIRONMENT`: Середовище (production)

## Масштабування

Застосунок налаштований на автоматичне масштабування:

- **Мінімальна кількість подів**: 2
- **Максимальна кількість подів**: 6
- **Тригер масштабування**: CPU > 70% або Memory > 70%

## Безпека

- Всі ресурси створюються з відповідними тегами
- EKS кластер розташований в приватних підмережах
- ECR репозиторій має політику доступу
- Django застосунок працює в production режимі

## Видалення інфраструктури

```bash
# Видалення застосунку
helm uninstall django-app

# Видалення інфраструктури
terraform destroy
```

## Підтримка

Для питань або проблем звертайтеся до документації:

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Amazon EKS](https://docs.aws.amazon.com/eks/)
- [Helm Documentation](https://helm.sh/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
