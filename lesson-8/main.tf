terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# Підключаємо модуль S3 та DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "nataliia-khodorova-terraform-backend"
  table_name  = "terraform-locks"
}

# Підключаємо модуль VPC
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_name           = "lesson-8-vpc"
}

# Підключаємо модуль ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-8-ecr"
  scan_on_push = true
}

# Підключаємо модуль EKS
module "eks" {
  source = "./modules/eks"

  cluster_name    = "lesson-8-eks-cluster"
  cluster_version = "1.28"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids

  node_group_name           = "main-node-group"
  node_group_instance_types = ["t3.medium"]
  node_group_desired_size   = 2
  node_group_max_size       = 4
  node_group_min_size       = 1

  tags = {
    Environment = "Production"
    Project     = "Lesson-8"
  }
}

# Підключаємо модуль Jenkins
module "jenkins" {
  source = "./modules/jenkins"

  # EKS cluster змінні
  cluster_name                       = module.eks.cluster_name
  cluster_endpoint                   = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data

  jenkins_namespace      = "jenkins"
  jenkins_admin_password = "admin123"

  # ECR credentials для Jenkins
  ecr_repository_url = module.ecr.repository_url
  aws_region         = "us-west-2"

  # Git repository для оновлення Helm chart
  git_repo_url       = "https://github.com/your-username/my-microservice-project.git"
  git_credentials_id = "github-credentials"
}

# Підключаємо модуль RDS
module "rds" {
  source = "./modules/rds"

  depends_on = [module.vpc]

  # Основні налаштування
  use_aurora = false # Звичайна RDS instance
  identifier = "lesson-8-db"

  # Двигун бази даних
  engine         = "postgres"
  engine_version = "14.9"
  instance_class = "db.t3.micro"

  # База даних
  database_name   = "django_app"
  master_username = "admin"
  master_password = "admin123456"

  # Мережа
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  # Додаткові налаштування
  multi_az          = false
  storage_encrypted = true

  tags = {
    Environment = "Production"
    Project     = "Lesson-8"
  }
}

# Підключаємо модуль Argo CD
module "argo_cd" {
  source = "./modules/argo_cd"

  # EKS cluster змінні
  cluster_name                       = module.eks.cluster_name
  cluster_endpoint                   = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data

  argo_namespace      = "argocd"
  argo_admin_password = "admin123"

  # Налаштування для Argo CD Application
  app_name                 = "django-app"
  app_namespace            = "django-app"
  git_repo_url             = "https://github.com/your-username/my-microservice-project.git"
  git_repo_path            = "lesson-8/charts/django-app"
  git_repo_target_revision = "main"

  # ECR repository для образів
  ecr_repository_url = module.ecr.repository_url
}

# Підключаємо модуль Monitoring (Prometheus + Grafana)
module "monitoring" {
  source = "./modules/monitoring"

  # EKS cluster змінні
  cluster_name                       = module.eks.cluster_name
  cluster_endpoint                   = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data

  monitoring_namespace = "monitoring"
}
