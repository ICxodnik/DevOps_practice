# Фінальний проєкт: DevOps Infrastructure на AWS

Повна автоматизація DevOps інфраструктури на AWS з використанням Terraform, включаючи Kubernetes кластер (EKS), CI/CD з Jenkins та Argo CD, базу даних RDS/Aurora, контейнерний реєстр ECR та моніторинг з Prometheus та Grafana.

## Опис проєкту

Цей проєкт демонструє повну автоматизацію DevOps інфраструктури на AWS для розгортання Django додатку з повним CI/CD циклом та моніторингом.

### Основні компоненти:

- **Infrastructure as Code**: Terraform модулі для всіх компонентів
- **Kubernetes**: EKS кластер з автоматичним масштабуванням
- **CI/CD**: Jenkins для збірки та Argo CD для GitOps розгортання
- **База даних**: Гнучкий модуль RDS (PostgreSQL/MySQL або Aurora)
- **Моніторинг**: Prometheus та Grafana для відстеження метрик
- **Django Application**: Туристичний трекер для відстеження відвіданих країн

## Туристичний трекер - Django додаток

**Туристичний трекер** - це веб-застосунок на Django, який дозволяє користувачам відстежувати країни, які вони відвідали. Додаток надає зручний інтерфейс для управління особистим списком відвіданих країн та візуалізацію на інтерактивній карті.

### Функціонал:

- **Реєстрація та авторизація**: Користувачі можуть створювати облікові записи та входити в систему
- **Відмітка країн**: Простий клік на країну на інтерактивній карті (Leaflet) дозволяє відмітити її як відвідану
- **Статистика**: Автоматичний підрахунок кількості відвіданих країн та відсотку від загальної кількості
- **Список країн**: Перегляд всіх країн світу з можливістю фільтрації та пошуку
- **Персональний профіль**: Кожен користувач має свій власний список відвіданих країн

### Технології додатку:

- **Django 4.2** - веб-фреймворк
- **PostgreSQL** - база даних для зберігання країн та відвідувань
- **Leaflet** - інтерактивна карта світу
- **Gunicorn** - WSGI сервер для production
- **WhiteNoise** - обслуговування статичних файлів

## Швидкий старт

Детальні інструкції з розгортання дивіться в [FINAL_PROJECT.md](FINAL_PROJECT.md)

### Основні кроки:

1. **Підготовка середовища**:

   ```bash
   git clone https://github.com/icxodnik/DevOps_practice.git
   cd DevOps_practice
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   export AWS_DEFAULT_REGION="us-west-2"
   ```

2. **Розгортання інфраструктури**:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Налаштування kubectl**:

   ```bash
   aws eks update-kubeconfig --name fn-project-eks-cluster --region us-west-2
   ```

4. **Доступ до сервісів**:
   - Jenkins: `kubectl port-forward svc/jenkins 8080:8080 -n jenkins`
   - Argo CD: `kubectl port-forward svc/argocd-server 8081:443 -n argocd`
   - Grafana: `kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring`

Або використайте скрипт швидкого старту:

```bash
./quick-start.sh
```

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
- **RDS**: База даних (PostgreSQL або Aurora)
- **Jenkins**: CI/CD сервер
- **Argo CD**: GitOps контролер
- **Prometheus + Grafana**: Моніторинг інфраструктури та додатків

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
DevOps_practice/
├── main.tf                  # Головний файл Terraform
├── backend.tf                # Налаштування S3 backend
├── outputs.tf                # Виводи ресурсів
├── Jenkinsfile               # CI/CD pipeline
│
├── modules/                  # Terraform модулі
│   ├── s3-backend/          # S3 та DynamoDB
│   ├── vpc/                 # VPC та підмережі
│   ├── ecr/                 # ECR репозиторій
│   ├── eks/                 # EKS кластер
│   ├── rds/                 # RDS база даних
│   ├── jenkins/             # Jenkins сервер
│   ├── argo_cd/             # Argo CD контролер
│   └── monitoring/          # Prometheus + Grafana
│
├── charts/                   # Helm charts
│   └── django-app/          # Django додаток
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── configmap.yaml
│           ├── hpa.yaml
│           └── _helpers.tpl
│
├── django-app/              # Django додаток
│   ├── Dockerfile
│   ├── docker-compose.yaml
│   ├── Jenkinsfile
│   └── travel_project/      # Django проєкт
│
├── examples/                # Приклади використання модулів
│   ├── aurora-example.tf
│   ├── aurora-mysql-example.tf
│   ├── mysql-example.tf
│   └── postgres-example.tf
│
└── Документація:
    ├── README.md            # Основна документація
    ├── FINAL_PROJECT.md     # Інструкції фінального проєкту
    ├── IMPLEMENTATION_SUMMARY.md
    ├── jenkins-setup.md
    └── argocd-setup.md
```

## Встановлення

### 1. Підготовка

```bash
# Клонування репозиторію
git clone https://github.com/icxodnik/DevOps_practice.git
cd DevOps_practice

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

## Розгортання додатку

Додаток можна розгорнути в різних середовищах:

### 1. Локальне розгортання (Docker Compose)

Найпростіший спосіб запустити додаток локально з PostgreSQL:

```bash
cd django-app
docker-compose -f docker-compose.local.yaml up -d
```

Додаток буде доступний за адресою:

- **http://localhost:8000** - Django застосунок
- **http://localhost:5432** - PostgreSQL база даних

**Що включає**:

- Автоматичне створення бази даних
- Виконання міграцій
- Завантаження списку країн
- Готовий до роботи додаток

**Створення суперкористувача**:

```bash
docker-compose -f docker-compose.local.yaml exec django-app python manage.py createsuperuser
```

**Зупинка**:

```bash
docker-compose -f docker-compose.local.yaml down
# Для видалення даних БД:
docker-compose -f docker-compose.local.yaml down -v
```

### 2. Локальне розгортання без Docker

Для розробки без Docker:

```bash
cd django-app

# Встановлення залежностей
pip install -r requirements.txt

# Налаштування бази даних (створіть PostgreSQL базу)
# Оновіть settings.py з параметрами підключення до БД

# Виконання міграцій
python manage.py migrate

# Завантаження країн
python manage.py load_countries

# Створення суперкористувача
python manage.py createsuperuser

# Запуск сервера розробки
python manage.py runserver
```

### 3. Розгортання в AWS (Production)

Повна інструкція в [FINAL_PROJECT.md](FINAL_PROJECT.md):

```bash
# Розгортання інфраструктури
terraform init
terraform plan
terraform apply

# Налаштування kubectl
aws eks update-kubeconfig --name fn-project-eks-cluster --region us-west-2

# Додаток автоматично розгортається через Argo CD
```

### 4. Розгортання в іншому Kubernetes кластері

Якщо у вас є інший Kubernetes кластер (не AWS EKS):

1. **Створіть Docker образ**:

   ```bash
   cd django-app
   docker build -t your-registry/travel-tracker:latest .
   docker push your-registry/travel-tracker:latest
   ```

2. **Оновіть Helm chart** (`charts/django-app/values.yaml`):

   ```yaml
   image:
     repository: your-registry/travel-tracker
     tag: latest
   ```

3. **Розгорніть через Helm**:
   ```bash
   helm install travel-tracker ./charts/django-app -n django-app --create-namespace
   ```

### Management команди

```bash
# Завантаження країн у базу даних
python manage.py load_countries

# Створення суперкористувача
python manage.py createsuperuser

# Виконання міграцій
python manage.py migrate

# Збір статичних файлів
python manage.py collectstatic
```

### Налаштування бази даних

Для локального розгортання без Docker створіть файл `.env` в `django-app/`:

```env
POSTGRES_DB=travel_tracker
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
SECRET_KEY=your-secret-key
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
```

Або використайте `env.example` як шаблон.

**Примітка**: Для Docker Compose використовуйте `docker-compose.local.yaml`, який автоматично налаштовує базу даних.

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

## Додаткова документація

- [FINAL_PROJECT.md](FINAL_PROJECT.md) - Детальні інструкції фінального проєкту
- [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - Опис реалізації
- [jenkins-setup.md](jenkins-setup.md) - Налаштування Jenkins
- [argocd-setup.md](argocd-setup.md) - Налаштування Argo CD
- [modules/rds/README.md](modules/rds/README.md) - Документація модуля RDS
- [django-app/README.md](django-app/README.md) - Документація Django додатку "Туристичний трекер"
