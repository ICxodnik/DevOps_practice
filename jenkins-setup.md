# Jenkins Pipeline Setup Instructions

## Після розгортання інфраструктури

### 1. Доступ до Jenkins

1. Отримайте URL Jenkins:

   ```bash
   terraform output jenkins_url
   ```

2. Відкрийте Jenkins в браузері

3. Увійдіть з:
   - Username: `admin`
   - Password: `admin123`

### 2. Створення Pipeline Job

1. Натисніть "New Item" або "Create new jobs"

2. Введіть назву job (наприклад, "django-cicd")

3. Виберіть "Pipeline" і натисніть "OK"

4. В розділі "Pipeline" виберіть "Pipeline script from SCM"

5. Виберіть "Git" як SCM

6. Введіть Repository URL:

   ```
   https://github.com/your-username/my-microservice-project.git
   ```

7. Виберіть гілку (зазвичай `main` або `master`)

8. Вкажіть шлях до Jenkinsfile:

   ```
   Jenkinsfile
   ```

9. Натисніть "Save"

### 3. Налаштування Git Credentials

1. Перейдіть до "Manage Jenkins" > "Manage Credentials"

2. Натисніть "System" > "Global credentials" > "Add Credentials"

3. Виберіть тип "Username with password"

4. Введіть:

   - ID: `github-credentials`
   - Username: ваш GitHub username
   - Password: ваш GitHub personal access token

5. Натисніть "OK"

### 4. Налаштування ECR Repository

1. Отримайте ECR repository URL:

   ```bash
   terraform output ecr_repository_url
   ```

2. Оновіть Jenkinsfile, замінивши:
   ```groovy
   ECR_REPOSITORY = 'your-ecr-repository-url'
   ```
   на ваш ECR URL

### 5. Запуск Pipeline

1. Поверніться до вашого pipeline job

2. Натисніть "Build Now"

3. Моніторте виконання в "Build History"

## Troubleshooting

### Проблеми з підключенням до Git

- Перевірте Git credentials та їх валідність
- Перевірте правильність URL репозиторію
- Перевірте права доступу до репозиторію
- Перевірте налаштування Jenkins credentials

### Проблеми з пушингом в ECR

- Перевірте IAM роль Jenkins та її права
- Перевірте правильність ECR repository URL
- Перевірте AWS credentials та регіон
- Перевірте ServiceAccount annotations

### Проблеми з оновленням Helm chart

- Перевірте Git credentials та права доступу
- Перевірте права на push в репозиторій
- Перевірте правильність шляху до values.yaml
- Перевірте налаштування Git в pipeline

## Корисні команди

```bash
# Перевірка статусу Jenkins
kubectl get pods -n jenkins

# Перегляд логів Jenkins
kubectl logs -n jenkins -l app.kubernetes.io/name=jenkins

# Отримання Jenkins admin password
kubectl get secret -n jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
```
