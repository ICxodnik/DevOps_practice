FROM python:3.11-slim

# Встановлюємо системні залежності
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Встановлюємо робочу директорію
WORKDIR /app

# Копіюємо файли залежностей
COPY requirements.txt .

# Встановлюємо Python залежності
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо код застосунку
COPY . .

# Створюємо директорію для staticfiles з правильними правами
RUN mkdir -p /app/staticfiles

# Створюємо користувача для безпеки
RUN useradd --create-home --shell /bin/bash app && \
    chown -R app:app /app

# Відкриваємо порт
EXPOSE 8000

# Команда за замовчуванням (може бути перевизначена в docker-compose)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "travel_project.wsgi:application"] 