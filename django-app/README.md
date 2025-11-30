# Туристичний трекер - Django додаток

Веб-застосунок для відстеження відвіданих країн з інтерактивною картою та статистикою.

## Опис

Туристичний трекер дозволяє користувачам:

- Реєструватися та входити в систему
- Відмічати країни, які вони відвідали, на інтерактивній карті
- Переглядати статистику відвіданих країн
- Бачити список всіх країн світу

## Швидкий старт

### Варіант 1: Docker Compose (рекомендовано)

```bash
# Запуск з PostgreSQL
docker-compose -f docker-compose.local.yaml up -d

# Створення суперкористувача
docker-compose -f docker-compose.local.yaml exec django-app python manage.py createsuperuser

# Перегляд логів
docker-compose -f docker-compose.local.yaml logs -f django-app
```

Додаток буде доступний на http://localhost:8000

### Варіант 2: Локальна розробка

```bash
# Встановлення залежностей
pip install -r requirements.txt

# Налаштування бази даних (створіть PostgreSQL базу)
# Створіть файл .env з налаштуваннями:
# POSTGRES_DB=travel_tracker
# POSTGRES_USER=postgres
# POSTGRES_PASSWORD=your_password
# POSTGRES_HOST=localhost
# POSTGRES_PORT=5432

# Міграції
python manage.py migrate

# Завантаження країн
python manage.py load_countries

# Створення суперкористувача
python manage.py createsuperuser

# Запуск сервера
python manage.py runserver
```

## Структура проєкту

```
django-app/
├── travel_project/          # Основний Django проєкт
│   ├── settings.py         # Налаштування
│   ├── urls.py             # URL конфігурація
│   └── wsgi.py              # WSGI конфігурація
├── travel_tracker/          # Django додаток
│   ├── models.py           # Моделі (Country, UserVisit)
│   ├── views.py            # Views
│   ├── templates/          # HTML шаблони
│   └── management/commands/ # Management команди
├── Dockerfile              # Docker образ
├── docker-compose.local.yaml # Docker Compose з PostgreSQL
└── requirements.txt        # Python залежності
```

## Management команди

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

## Налаштування

### Змінні середовища

Створіть файл `.env` або використайте `env.example`:

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

## API Endpoints

- `/` - Головна сторінка з картою
- `/countries/` - Список країн
- `/register/` - Реєстрація
- `/login/` - Вхід
- `/logout/` - Вихід
- `/toggle-country/<id>/` - Відмітка/зняття відмітки країни
- `/health/` - Health check endpoint
- `/admin/` - Адмін-панель

## Розгортання в production

### Docker

```bash
docker build -t travel-tracker:latest .
docker run -p 8000:8000 \
  -e POSTGRES_HOST=your-db-host \
  -e POSTGRES_DB=travel_tracker \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=your-password \
  travel-tracker:latest
```

### Kubernetes

Використайте Helm chart з `../charts/django-app/`:

```bash
helm install travel-tracker ../charts/django-app -n django-app --create-namespace
```

## Troubleshooting

### Проблеми з підключенням до БД

Перевірте змінні середовища та доступність PostgreSQL:

```bash
# Перевірка підключення
psql -h localhost -U postgres -d travel_tracker
```

### Проблеми з міграціями

```bash
# Скидання міграцій (увага: видалить дані!)
python manage.py migrate travel_tracker zero
python manage.py migrate
```

### Проблеми зі статичними файлами

```bash
python manage.py collectstatic --noinput
```

## Ліцензія

MIT
