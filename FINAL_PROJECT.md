# Фінальний проєкт: Розгортання інфраструктури DevOps на AWS

## Опис проєкту

Цей проєкт демонструє повну автоматизацію DevOps інфраструктури на AWS з використанням Terraform, включаючи:

- Kubernetes кластер (EKS) з підтримкою CI/CD
- Jenkins для автоматизації збірки та деплою
- Argo CD для GitOps управління застосунками
- База даних (RDS або Aurora)
- Контейнерний реєстр (ECR)
- Моніторинг з Prometheus та Grafana

## Структура проєкту

```
DevOps_practice/
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf               # Загальні виводи ресурсів
├── Jenkinsfile              # CI/CD pipeline
│
├── modules/                 # Каталог з усіма модулями
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   ├── vpc/                 # Модуль для VPC
│   ├── ecr/                 # Модуль для ECR
│   ├── eks/                 # Модуль для Kubernetes кластера
│   ├── rds/                 # Модуль для RDS
│   ├── jenkins/             # Модуль для Helm-установки Jenkins
│   ├── argo_cd/             # Модуль для Helm-установки Argo CD
│   └── monitoring/          # Модуль для Prometheus + Grafana
│
├── charts/                  # Helm charts
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
└── examples/                # Приклади використання модулів
    ├── aurora-example.tf
    ├── aurora-mysql-example.tf
    ├── mysql-example.tf
    └── postgres-example.tf
```

## Покрокова інструкція розгортання

### 1. Підготовка середовища

```bash
# Клонування репозиторію
git clone https://github.com/your-username/my-microservice-project.git
cd my-microservice-project

# Налаштування AWS credentials
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-west-2"

# Перевірка наявності kubectl
kubectl version --client
```

### 2. Ініціалізація Terraform

```bash
# Ініціалізація Terraform
terraform init

# Перевірка конфігурації
terraform validate

# Перегляд плану розгортання
terraform plan
```

### 3. Розгортання інфраструктури

```bash
# Розгортання всієї інфраструктури
terraform apply

# Підтвердження розгортання (введіть 'yes')
```

**Час розгортання**: приблизно 15-20 хвилин

### 4. Налаштування kubectl

```bash
# Отримання конфігурації кластера
aws eks update-kubeconfig --name fn-project-eks-cluster --region us-west-2

# Перевірка підключення
kubectl get nodes
```

### 5. Перевірка статусу компонентів

```bash
# Перевірка Jenkins
kubectl get all -n jenkins

# Перевірка Argo CD
kubectl get all -n argocd

# Перевірка моніторингу
kubectl get all -n monitoring

# Перевірка Django додатку
kubectl get all -n django-app
```

### 6. Доступ до сервісів через Port Forwarding

#### Jenkins

```bash
# Port forwarding для Jenkins
kubectl port-forward svc/jenkins 8080:8080 -n jenkins

# Відкрийте в браузері: http://localhost:8080
# Username: admin
# Password: admin123 (або отримайте через terraform output jenkins_admin_password)
```

#### Argo CD

```bash
# Port forwarding для Argo CD
kubectl port-forward svc/argocd-server 8081:443 -n argocd

# Відкрийте в браузері: https://localhost:8081
# Username: admin
# Password: admin123 (або отримайте через terraform output argocd_admin_password)
```

#### Grafana

```bash
# Port forwarding для Grafana
kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring

# Відкрийте в браузері: http://localhost:3000
# Username: admin
# Password: admin123
```

#### Prometheus

```bash
# Port forwarding для Prometheus
kubectl port-forward svc/prometheus-operated 9090:9090 -n monitoring

# Відкрийте в браузері: http://localhost:9090
```

### 7. Перевірка CI/CD Pipeline

1. **Налаштування Jenkins Pipeline**:

   - Відкрийте Jenkins UI
   - Створіть новий Pipeline job
   - Вкажіть шлях до Jenkinsfile: `Jenkinsfile`
   - Налаштуйте Git credentials

2. **Запуск Pipeline**:

   - Зробіть зміни в коді Django додатку
   - Commit та push зміни в Git
   - Jenkins автоматично запустить pipeline

3. **Перевірка Argo CD**:
   - Відкрийте Argo CD UI
   - Перевірте статус Application "django-app"
   - Argo CD автоматично синхронізує зміни з Git

### 8. Моніторинг та метрики

1. **Grafana Dashboards**:

   - Відкрийте Grafana UI
   - Перейдіть до Dashboards
   - Використовуйте вбудовані дашборди для Kubernetes та додатків

2. **Prometheus Metrics**:
   - Відкрийте Prometheus UI
   - Виконайте запити для перегляду метрик
   - Приклад: `kube_pod_status_phase`

## Отримання інформації про розгортання

```bash
# Всі outputs
terraform output

# Конкретні outputs
terraform output jenkins_url
terraform output argocd_url
terraform output grafana_url
terraform output ecr_repository_url
terraform output rds_instance_endpoint
```

## Важливі зауваження

### ⚠️ Видалення інфраструктури

**ВАЖЛИВО**: Для уникнення непередбачуваних витрат обов'язково видаляйте невикористані ресурси:

```bash
# Видалення всієї інфраструктури
terraform destroy

# Підтвердження видалення (введіть 'yes')
```

**Увага**: При видаленні інфраструктури також видаляється S3-бакет і DynamoDB-таблиця, які використовуються для збереження Terraform стейту. Якщо потрібно зберегти стейт, виконайте backup перед видаленням.

### Повторне розгортання інфраструктури

При повторному розгортанні інфраструктури (наприклад, після видалення):

1. Переконайтеся, що S3 бакет та DynamoDB таблиця для Terraform state існують
2. Якщо вони були видалені, створіть їх вручну або через окремий Terraform проєкт
3. Виконайте `terraform init` та `terraform apply`

## Troubleshooting

### Jenkins не може підключитися до EKS

- Перевірте IAM роль Jenkins
- Перевірте ServiceAccount
- Перевірте OIDC провайдер

### Argo CD не синхронізує зміни

- Перевірте Git репозиторій URL
- Перевірте Application конфігурацію
- Перевірте права доступу до репозиторію

### Проблеми з розгортанням додатку

- Перевірте ECR образ та теги
- Перевірте Kubernetes поди та їх статус
- Перегляньте логи подів для діагностики
- Перевірте ресурси кластера (CPU/Memory)

### Проблеми з моніторингом

- Перевірте статус подів Prometheus та Grafana
- Перевірте ServiceMonitor ресурси
- Перевірте права доступу до метрик

## Корисні команди

```bash
# Перевірка статусу всіх компонентів
kubectl get pods --all-namespaces

# Перегляд логів
kubectl logs -n jenkins -l app.kubernetes.io/name=jenkins
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server
kubectl logs -n monitoring -l app.kubernetes.io/name=prometheus
kubectl logs -n django-app -l app.kubernetes.io/name=django-app

# Отримання паролів
terraform output jenkins_admin_password
terraform output argocd_admin_password
terraform output grafana_admin_password

# Перевірка сервісів
kubectl get svc --all-namespaces

# Перевірка ingress
kubectl get ingress --all-namespaces
```

## Критерії оцінювання

- ✅ Створено середовище з коректною архітектурою (20 балів)
- ✅ Налаштовано безпеку через VPC, IAM, Security Groups (20 балів)
- ✅ Розгорнуто застосунок в AWS з CI/CD (30 балів)
- ✅ Налаштовано моніторинг та автомасштабування (20 балів)
- ✅ Коректне оформлення та зрозумілість документації (10 балів)

## Додаткова інформація

Детальні інструкції по кожному компоненту:

- [Jenkins Setup](jenkins-setup.md)
- [Argo CD Setup](argocd-setup.md)
- [Implementation Summary](IMPLEMENTATION_SUMMARY.md)
- [RDS Module Documentation](modules/rds/README.md)

## Підтримка

При виникненні проблем звертайтеся до ментора у Slack.
