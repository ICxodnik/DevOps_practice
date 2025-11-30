#!/bin/bash

# Скрипт для збірки та завантаження Docker образу в ECR

set -e

# Конфігурація
AWS_REGION="us-west-2"
ECR_REPOSITORY_NAME="lesson-7-ecr"
IMAGE_TAG="latest"
DOCKERFILE_PATH="../django-app"

# Отримуємо AWS Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Формуємо повний URL репозиторію
ECR_REPOSITORY_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY_NAME}"

echo "🚀 Починаємо збірку та завантаження Docker образу..."
echo "📍 AWS Region: ${AWS_REGION}"
echo "📍 AWS Account ID: ${AWS_ACCOUNT_ID}"
echo "📍 ECR Repository: ${ECR_REPOSITORY_URI}"
echo "📍 Image Tag: ${IMAGE_TAG}"

# Переходимо до директорії з Dockerfile
cd "${DOCKERFILE_PATH}"

# Збірка Docker образу
echo "🔨 Збірка Docker образу..."
docker build -t "${ECR_REPOSITORY_NAME}:${IMAGE_TAG}" .

# Тегування образу для ECR
echo "🏷️ Тегування образу для ECR..."
docker tag "${ECR_REPOSITORY_NAME}:${IMAGE_TAG}" "${ECR_REPOSITORY_URI}:${IMAGE_TAG}"

# Авторизація в ECR
echo "🔐 Авторизація в ECR..."
aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${ECR_REPOSITORY_URI}"

# Завантаження образу в ECR
echo "📤 Завантаження образу в ECR..."
docker push "${ECR_REPOSITORY_URI}:${IMAGE_TAG}"

echo "✅ Образ успішно завантажено в ECR!"
echo "📍 URL образу: ${ECR_REPOSITORY_URI}:${IMAGE_TAG}"

# Повертаємося до початкової директорії
cd - > /dev/null 