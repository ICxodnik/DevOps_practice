# Argo CD Setup Instructions

## Після розгортання інфраструктури

### 1. Доступ до Argo CD

1. Отримайте URL Argo CD:

   ```bash
   terraform output argocd_url
   ```

2. Відкрийте Argo CD в браузері

3. Увійдіть з:
   - Username: `admin`
   - Password: `admin123`

### 2. Перевірка Application

1. В головному меню Argo CD ви побачите Application "django-app"

2. Натисніть на нього для перегляду деталей

3. Перевірте статус синхронізації:
   - ✅ Synced: додаток синхронізовано
   - ⚠️ Out of Sync: є відмінності
   - ❌ Failed: помилка синхронізації

### 3. Ручна синхронізація (якщо потрібно)

1. В Application деталях натисніть "Sync"

2. Виберіть параметри синхронізації:

   - Prune: видалити ресурси, які більше не існують
   - Self Heal: автоматично виправити відхилення

3. Натисніть "Synchronize"

### 4. Моніторинг розгортання

1. В Application деталях перейдіть на вкладку "Pods"

2. Перевірте статус подів:

   - Running: под працює
   - Pending: под очікує ресурсів
   - Failed: помилка запуску

3. Перейдіть на вкладку "Services" для перегляду сервісів

### 5. Доступ до додатку

1. Отримайте URL сервісу Django:

   ```bash
   kubectl get svc -n django-app
   ```

2. Знайдіть LoadBalancer URL в колонці EXTERNAL-IP

3. Відкрийте URL в браузері

## Troubleshooting

### Application не синхронізується

- Перевірте Git репозиторій URL
- Перевірте шлях до Helm chart
- Перевірте права доступу до репозиторію

### Проблеми з подами

- Перевірте ECR образ та теги
- Перевірте доступність ресурсів кластера
- Перегляньте логи подів для діагностики
- Перевірте image pull secrets

### Сервіс недоступний

- Перевірте LoadBalancer статус
- Перевірте порти сервісу
- Перевірте health checks

## Корисні команди

```bash
# Перевірка статусу Argo CD
kubectl get pods -n argocd

# Перегляд логів Argo CD
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server

# Отримання Argo CD admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Перевірка Application статусу
kubectl get application -n argocd

# Перевірка Django додатку
kubectl get pods -n django-app
kubectl get svc -n django-app

# Перегляд логів Django подів
kubectl logs -n django-app -l app.kubernetes.io/name=django-app
```

## GitOps Workflow

1. **Зміни в коді**: Розробник робить зміни в Django коді

2. **Jenkins Pipeline**:

   - Збирає новий Docker образ
   - Пушить в ECR
   - Оновлює тег в values.yaml
   - Комітить зміни в Git

3. **Argo CD автоматично**:

   - Відстежує зміни в Git
   - Синхронізує нову версію
   - Розгортає оновлений додаток

4. **Моніторинг**: Перевірте статус в Argo CD UI

## Налаштування автоматичної синхронізації

Argo CD вже налаштований на автоматичну синхронізацію через Terraform. Якщо потрібно змінити налаштування:

1. В Application деталях натисніть "App Details"

2. Перейдіть на вкладку "Parameters"

3. Відредагуйте sync policy:

   ```yaml
   syncPolicy:
     automated:
       prune: true
       selfHeal: true
     syncOptions:
       - CreateNamespace=true
   ```

4. Натисніть "Save"
