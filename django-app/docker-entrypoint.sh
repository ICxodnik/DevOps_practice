#!/bin/bash

echo "=== Початок ініціалізації Django ==="

# Створюємо директорію staticfiles з правильними правами
echo "Створення директорії staticfiles..."
mkdir -p /app/staticfiles
chmod -R 755 /app/staticfiles 2>/dev/null || true

# Виконуємо міграції
echo "Виконання міграцій..."
if ! python manage.py migrate; then
    echo "Помилка при міграціях, але продовжуємо..."
fi

# Завантажуємо країни
echo "Завантаження країн..."
if ! python manage.py load_countries; then
    echo "Попередження: помилка при завантаженні країн, але продовжуємо..."
fi

# Збираємо статичні файли
echo "Збір статичних файлів..."
if ! python manage.py collectstatic --noinput --clear; then
    echo "Попередження: помилка при зборі статичних файлів, але продовжуємо..."
    # Спробуємо створити базові директорії
    mkdir -p /app/staticfiles/admin /app/staticfiles/static 2>/dev/null || true
fi

echo "=== Запуск Gunicorn ==="
# Запускаємо Gunicorn
# Для локального розгортання залишаємося root (для простоти)
exec gunicorn --bind 0.0.0.0:8000 --workers 3 travel_project.wsgi:application

