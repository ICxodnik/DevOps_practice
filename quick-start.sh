#!/bin/bash

# Quick Start Script for Lesson 8: Jenkins + Helm + Terraform + Argo CD

set -e

echo "🚀 Starting Lesson 8: Jenkins + Helm + Terraform + Argo CD CI/CD Pipeline"
echo "=================================================================="

# Check if AWS credentials are set
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "❌ Error: AWS credentials not set"
    echo "Please set the following environment variables:"
    echo "export AWS_ACCESS_KEY_ID='your-access-key'"
    echo "export AWS_SECRET_ACCESS_KEY='your-secret-key'"
    echo "export AWS_DEFAULT_REGION='us-west-2'"
    exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Error: Terraform is not installed"
    echo "Please install Terraform: https://www.terraform.io/downloads.html"
    exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "❌ Error: kubectl is not installed"
    echo "Please install kubectl: https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi

echo "✅ Prerequisites check passed"

# Initialize Terraform
echo "📦 Initializing Terraform..."
terraform init

# Plan deployment
echo "📋 Planning deployment..."
terraform plan

# Ask for confirmation
read -p "Do you want to proceed with the deployment? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled"
    exit 1
fi

# Apply deployment
echo "🚀 Deploying infrastructure..."
terraform apply -auto-approve

echo "✅ Infrastructure deployment completed!"

# Get outputs
echo "📊 Getting deployment information..."
echo "=================================================================="

echo "🔗 Jenkins URL:"
terraform output jenkins_url

echo "🔑 Jenkins Admin Password:"
terraform output jenkins_admin_password

echo "🔗 Argo CD URL:"
terraform output argocd_url

echo "🔑 Argo CD Admin Password:"
terraform output argocd_admin_password

echo "🐳 ECR Repository URL:"
terraform output ecr_repository_url

echo "🔗 Grafana URL:"
terraform output grafana_url

echo "🔑 Grafana Admin Password:"
terraform output grafana_admin_password

echo "🔗 Prometheus URL:"
terraform output prometheus_url

echo "=================================================================="
echo "🎉 Deployment completed successfully!"
echo ""
echo "Next steps:"
echo "1. Configure kubectl: aws eks update-kubeconfig --name fn-project-eks-cluster --region us-west-2"
echo "2. Access Jenkins at the URL above (use port-forward if needed)"
echo "3. Access Argo CD at the URL above (use port-forward if needed)"
echo "4. Access Grafana at the URL above (use port-forward if needed)"
echo "5. Create a new pipeline job in Jenkins using the Jenkinsfile"
echo "6. Monitor the Argo CD application for automatic deployment"
echo ""
echo "For more information, see README.md and FINAL_PROJECT.md" 