#!/bin/bash
# Скрипт для перебудови та запуску

set -e

echo "=== Зупинка контейнерів ==="
docker-compose -f docker-compose.local.yaml down

echo ""
echo "=== Перебудова образу Django ==="
docker-compose -f docker-compose.local.yaml build --no-cache django-app

echo ""
echo "=== Запуск контейнерів ==="
docker-compose -f docker-compose.local.yaml up -d

echo ""
echo "=== Очікування запуску (10 секунд) ==="
sleep 10

echo ""
echo "=== Статус контейнерів ==="
docker-compose -f docker-compose.local.yaml ps

echo ""
echo "=== Логи Django (останні 30 рядків) ==="
docker-compose -f docker-compose.local.yaml logs django-app --tail=30

echo ""
echo "=== Якщо все добре, додаток доступний на: ==="
echo "  - http://localhost (через Nginx)"
echo "  - http://localhost:8000 (напряму до Django)"

