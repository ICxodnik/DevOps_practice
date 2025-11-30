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
lesson-8/
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
cd my-microservice-project/lesson-8

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
