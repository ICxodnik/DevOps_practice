#!/bin/bash
echo "=== Логи Django контейнера (останні 100 рядків) ==="
docker-compose -f docker-compose.local.yaml logs django-app --tail=100

echo ""
echo "=== Спробуйте запустити контейнер вручну ==="
echo "docker-compose -f docker-compose.local.yaml run --rm django-app /app/docker-entrypoint.sh"

