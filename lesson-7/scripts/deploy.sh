#!/bin/bash

# Скрипт для розгортання Django застосунку через Helm

set -e

# Конфігурація
RELEASE_NAME="django-app"
CHART_PATH="./charts/django-app"
NAMESPACE="default"
AWS_REGION="us-west-2"

# Отримуємо AWS Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "🚀 Починаємо розгортання Django застосунку..."
echo "📍 Release Name: ${RELEASE_NAME}"
echo "📍 Namespace: ${NAMESPACE}"
echo "📍 AWS Account ID: ${AWS_ACCOUNT_ID}"

# Оновлюємо values.yaml з правильним AWS Account ID (якщо потрібно)
echo "📝 Перевірка values.yaml..."
if grep -q "123456789012" "${CHART_PATH}/values.yaml" 2>/dev/null; then
  sed -i.bak "s/123456789012/${AWS_ACCOUNT_ID}/g" "${CHART_PATH}/values.yaml"
  rm -f "${CHART_PATH}/values.yaml.bak"
fi

# Перевіряємо підключення до кластера
echo "🔍 Перевірка підключення до кластера..."
kubectl cluster-info

# Створюємо namespace якщо не існує
echo "📁 Створення namespace якщо потрібно..."
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

# Розгортаємо застосунок через Helm
echo "📦 Розгортання через Helm..."
helm upgrade --install ${RELEASE_NAME} ${CHART_PATH} \
  --namespace ${NAMESPACE} \
  --set aws.accountId=${AWS_ACCOUNT_ID} \
  --set aws.region=${AWS_REGION} \
  --wait \
  --timeout=10m

# Перевіряємо статус розгортання
echo "🔍 Перевірка статусу розгортання..."
kubectl get pods -n ${NAMESPACE} -l app.kubernetes.io/name=django-app

# Отримуємо URL LoadBalancer
echo "🌐 Отримання URL LoadBalancer..."
kubectl get svc -n ${NAMESPACE} ${RELEASE_NAME} -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "LoadBalancer ще не готовий"

echo "✅ Розгортання завершено!"
echo "📋 Команди для перевірки:"
echo "  kubectl get pods -n ${NAMESPACE}"
echo "  kubectl get svc -n ${NAMESPACE}"
echo "  kubectl logs -n ${NAMESPACE} -l app.kubernetes.io/name=django-app" 