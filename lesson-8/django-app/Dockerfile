FROM python:3.11-slim

# Встановлюємо системні залежності
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Встановлюємо робочу директорію
WORKDIR /app

# Копіюємо файли залежностей
COPY requirements.txt .

# Встановлюємо Python залежності
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо код застосунку
COPY . .

# Створюємо користувача для безпеки
RUN useradd --create-home --shell /bin/bash app && chown -R app:app /app
USER app

# Відкриваємо порт
EXPOSE 8000

# Команда для запуску
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "travel_project.wsgi:application"] 