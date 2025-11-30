#!/bin/bash

# Скрипт для налаштування kubectl для роботи з EKS кластером

set -e

# Конфігурація
CLUSTER_NAME="lesson-7-eks-cluster"
AWS_REGION="us-west-2"

echo "🔧 Налаштування kubectl для EKS кластера..."
echo "📍 Cluster Name: ${CLUSTER_NAME}"
echo "📍 AWS Region: ${AWS_REGION}"

# Оновлюємо kubeconfig для кластера
echo "📝 Оновлення kubeconfig..."
aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}

# Перевіряємо підключення
echo "🔍 Перевірка підключення до кластера..."
kubectl cluster-info

# Перевіряємо вузли кластера
echo "🖥️ Перевірка вузлів кластера..."
kubectl get nodes

# Перевіряємо namespace
echo "📁 Перевірка namespace..."
kubectl get namespaces

echo "✅ kubectl налаштовано успішно!"
echo "📋 Команди для перевірки:"
echo "  kubectl get nodes"
echo "  kubectl get pods --all-namespaces"
echo "  kubectl get svc --all-namespaces" 