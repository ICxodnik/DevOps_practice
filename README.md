# Туристичний трекер

Docker-проєкт з Django, PostgreSQL та Nginx для відстеження відвіданих країн.

## Опис проєкту

Туристичний трекер - це веб-застосунок, який дозволяє користувачам:

- Реєструватися та входити в систему
- Відмічати країни, які вони відвідали
- Переглядати інтерактивну карту з відміченими країнами
- Бачити статистику відвіданих країн та відсоток відвіданих країн

## Технології

- **Django 4.2** - веб-фреймворк
- **PostgreSQL 15** - база даних
- **Nginx** - веб-сервер для проксирування запитів
- **Docker & Docker Compose** - контейнеризація
- **Leaflet** - інтерактивна карта
- **Gunicorn** - WSGI сервер

## Структура проєкту

```
DevOps_practice/
├── travel_project/          # Основний Django проєкт
│   ├── settings.py          # Налаштування проєкту
│   ├── urls.py              # URL конфігурація
│   └── wsgi.py              # WSGI конфігурація
├── travel_tracker/          # Django додаток
│   ├── models.py            # Моделі даних (Country, UserVisit)
│   ├── views.py             # Views для обробки запитів
│   ├── urls.py              # URL маршрути додатку
│   ├── templates/           # HTML шаблони
│   └── management/commands/ # Management команди
├── nginx/
│   └── nginx.conf           # Конфігурація Nginx
├── Dockerfile               # Dockerfile для Django
├── docker-compose.yml       # Docker Compose конфігурація
├── requirements.txt         # Python залежності
└── README.md                # Документація
```

## Встановлення та запуск

### Вимоги

- Docker
- Docker Compose

### Кроки запуску

1. Клонуйте репозиторій:

```bash
git clone <your-repo-url>
cd DevOps_practice
```

2. Запустіть проєкт за допомогою Docker Compose:

```bash
docker-compose up -d
```

3. Проєкт буде доступний за адресою:

   - **http://localhost** - через Nginx
   - **http://localhost:8000** - напряму до Django

4. Створіть суперкористувача для доступу до адмін-панелі (опціонально):

```bash
docker-compose exec web python manage.py createsuperuser
```

5. Адмін-панель доступна за адресою:
   - **http://localhost/admin**

## Використання

1. **Реєстрація**: Створіть новий акаунт на сторінці реєстрації
2. **Вхід**: Увійдіть у систему зі своїми обліковими даними
3. **Відмітка країн**: Клікніть на країну на карті, щоб відмітити її як відвідану
4. **Статистика**: Переглядайте кількість відвіданих країн та відсоток на головній сторінці

## Docker сервіси

- **web** - Django застосунок (порт 8000)
- **db** - PostgreSQL база даних (порт 5432)
- **nginx** - Nginx веб-сервер (порт 80)

## Management команди

Завантаження країн у базу даних:

```bash
docker-compose exec web python manage.py load_countries
```

## Зупинка проєкту

```bash
docker-compose down
```

Для видалення всіх даних (включаючи базу даних):

```bash
docker-compose down -v
```

## Розробка

Для локальної розробки без Docker:

1. Встановіть залежності:

```bash
pip install -r requirements.txt
```

2. Налаштуйте базу даних PostgreSQL

3. Виконайте міграції:

```bash
python manage.py migrate
python manage.py load_countries
```

4. Запустіть сервер розробки:

```bash
python manage.py runserver
```

# Lesson 8: Jenkins + Helm + Terraform + Argo CD CI/CD Pipeline

Цей проект демонструє повний CI/CD процес з використанням Jenkins, Helm, Terraform та Argo CD для автоматичного розгортання Django додатку в AWS EKS кластері.

## Архітектура

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Git Repo      │    │    Jenkins      │    │   Argo CD       │
│                 │    │                 │    │                 │
│ - Source Code   │───▶│ - Build Image   │───▶│ - Auto Sync     │
│ - Helm Charts   │    │ - Push to ECR   │    │ - Deploy App    │
│ - Jenkinsfile   │    │ - Update Chart  │    │ - GitOps        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                       │
                                ▼                       ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │   Amazon ECR    │    │   AWS EKS       │
                       │                 │    │                 │
                       │ - Docker Images │    │ - Kubernetes    │
                       │ - Image Tags    │    │ - Django App    │
                       └─────────────────┘    └─────────────────┘
```

## Компоненти

### 1. Infrastructure (Terraform)

- **S3 Backend**: Зберігання Terraform state
- **VPC**: Мережева інфраструктура
- **ECR**: Docker registry для образів
- **EKS**: Kubernetes кластер
- **Jenkins**: CI/CD сервер
- **Argo CD**: GitOps контролер

### 2. CI/CD Pipeline (Jenkins)

- Автоматична збірка Docker образів
- Публікація в Amazon ECR
- Оновлення Helm chart з новим тегом
- Push змін в Git репозиторій

### 3. GitOps (Argo CD)

- Автоматична синхронізація з Git
- Розгортання додатку в Kubernetes
- Відстеження стану розгортання

## Структура проекту

```
fn-project/
├── main.tf                  # Головний файл Terraform
├── backend.tf               # Налаштування S3 backend
├── outputs.tf               # Виводи ресурсів
├── Jenkinsfile              # CI/CD pipeline
├── modules/                 # Terraform модулі
│   ├── s3-backend/          # S3 та DynamoDB
│   ├── vpc/                 # VPC та підмережі
│   ├── ecr/                 # ECR репозиторій
│   ├── eks/                 # EKS кластер
│   ├── rds/                 # RDS база даних
│   ├── jenkins/             # Jenkins сервер
│   ├── argo_cd/             # Argo CD контролер
│   └── monitoring/          # Prometheus + Grafana
└── charts/                  # Helm charts
    └── django-app/          # Django додаток
        ├── Chart.yaml
        ├── values.yaml
        └── templates/
            ├── deployment.yaml
            ├── service.yaml
            ├── configmap.yaml
            ├── hpa.yaml
            └── _helpers.tpl
```

## Встановлення

### 1. Підготовка

```bash
# Клонування репозиторію
git clone https://github.com/your-username/my-microservice-project.git
cd my-microservice-project/fn-project

# Налаштування AWS credentials
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-west-2"
```

### 2. Розгортання інфраструктури

```bash
# Ініціалізація Terraform
terraform init

# План розгортання
terraform plan

# Розгортання
terraform apply
```

### 3. Налаштування Jenkins

1. Отримайте URL Jenkins з outputs:

   ```bash
   terraform output jenkins_url
   ```

2. Відкрийте Jenkins в браузері та увійдіть з:

   - Username: `admin`
   - Password: `admin123`

3. Створіть новий pipeline job з Jenkinsfile

### 4. Налаштування Argo CD

1. Отримайте URL Argo CD з outputs:

   ```bash
   terraform output argocd_url
   ```

2. Відкрийте Argo CD в браузері та увійдіть з:

   - Username: `admin`
   - Password: `admin123`

3. Перевірте статус Application

## Використання

### Запуск CI/CD Pipeline

1. Зробіть зміни в коді Django додатку
2. Commit та push зміни в Git
3. Jenkins автоматично запустить pipeline
4. Argo CD автоматично синхронізує зміни

### Перевірка статусу

```bash
# Перевірка Jenkins
kubectl get pods -n jenkins

# Перевірка Argo CD
kubectl get pods -n argocd

# Перевірка Django додатку
kubectl get pods -n django-app

# Перевірка сервісів
kubectl get svc -n django-app

# Перевірка моніторингу
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```

### Доступ до сервісів через Port Forwarding

```bash
# Jenkins
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
# Відкрийте http://localhost:8080

# Argo CD
kubectl port-forward svc/argocd-server 8081:443 -n argocd
# Відкрийте https://localhost:8081

# Grafana
kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
# Відкрийте http://localhost:3000

# Prometheus
kubectl port-forward svc/prometheus-operated 9090:9090 -n monitoring
# Відкрийте http://localhost:9090
```

## Налаштування

### Зміна Git репозиторію

Оновіть змінні в `main.tf`:

```hcl
module "jenkins" {
  # ...
  git_repo_url = "https://github.com/your-username/your-repo.git"
}

module "argo_cd" {
  # ...
  git_repo_url = "https://github.com/your-username/your-repo.git"
}
```

### Зміна ECR репозиторію

Оновіть в `Jenkinsfile`:

```groovy
environment {
    ECR_REPOSITORY = 'your-ecr-repository-url'
}
```

## Очищення

```bash
# Видалення всієї інфраструктури
terraform destroy
```

## Troubleshooting

### Jenkins не може підключитися до EKS

- Перевірте IAM роль Jenkins
- Перевірте ServiceAccount
- Перевірте OIDC провайдер

### Argo CD не синхронізує зміни

- Перевірте Git репозиторій
- Перевірте Application конфігурацію
- Перевірте права доступу до репозиторію

### Проблеми з розгортанням додатку

- Перевірте ECR образ та теги
- Перевірте Kubernetes поди та їх статус
- Перегляньте логи подів для діагностики
- Перевірте ресурси кластера (CPU/Memory)

## Корисні команди

```bash
# Отримання Jenkins admin password
kubectl get secret -n jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode

# Отримання Argo CD admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Перегляд логів Jenkins
kubectl logs -n jenkins -l app.kubernetes.io/name=jenkins

# Перегляд логів Argo CD
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server

# Перегляд логів Prometheus
kubectl logs -n monitoring -l app.kubernetes.io/name=prometheus

# Перегляд логів Grafana
kubectl logs -n monitoring -l app.kubernetes.io/name=grafana

# Перевірка метрик Prometheus
kubectl port-forward svc/prometheus-operated 9090:9090 -n monitoring
# Відкрийте http://localhost:9090 для перегляду метрик
```
