FROM python:3.11-slim

WORKDIR /app

# Встановлюємо системні залежності
RUN apt-get update && apt-get install -y \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Копіюємо requirements.txt та встановлюємо залежності
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо весь проєкт
COPY . .

# Створюємо директорію для статичних файлів
RUN mkdir -p /app/staticfiles

# Відкриваємо порт
EXPOSE 8000

# Команда для запуску Django
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "travel_project.wsgi:application"]


