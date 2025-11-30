# Data sources для отримання інформації про кластер та AWS
data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

locals {
  cluster_oidc_issuer_url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  # Витягуємо registry URL з repository URL (видаляємо назву репозиторію)
  # Використовуємо split для отримання першої частини URL
  ecr_registry_url = split("/", var.ecr_repository_url)[0]
}

# Створюємо namespace для Jenkins
resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.jenkins_namespace
  }
}

# Створюємо ServiceAccount для Jenkins з правами на роботу з AWS
resource "kubernetes_service_account" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = var.jenkins_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.jenkins_role.arn
    }
  }
}

# Створюємо IAM роль для Jenkins
resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(local.cluster_oidc_issuer_url, "https://", "")}"
        }
        Condition = {
          StringEquals = {
            "${replace(local.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:${var.jenkins_namespace}:jenkins"
          }
        }
      }
    ]
  })
}

# Політика для роботи з ECR
resource "aws_iam_role_policy" "jenkins_ecr_policy" {
  name = "jenkins-ecr-policy"
  role = aws_iam_role.jenkins_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "*"
      }
    ]
  })
}

# Встановлюємо Jenkins через Helm
resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = var.jenkins_repository
  chart      = "jenkins"
  version    = var.jenkins_chart_version
  namespace  = var.jenkins_namespace

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "controller.adminPassword"
    value = var.jenkins_admin_password
  }

  set {
    name  = "controller.serviceType"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.resources.requests.cpu"
    value = var.jenkins_cpu_request
  }

  set {
    name  = "controller.resources.requests.memory"
    value = var.jenkins_memory_request
  }

  set {
    name  = "controller.resources.limits.cpu"
    value = var.jenkins_cpu_limit
  }

  set {
    name  = "controller.resources.limits.memory"
    value = var.jenkins_memory_limit
  }

  depends_on = [
    kubernetes_namespace.jenkins,
    kubernetes_service_account.jenkins
  ]
}

# Створюємо ConfigMap з налаштуваннями Jenkins
resource "kubernetes_config_map" "jenkins_config" {
  metadata {
    name      = "jenkins-config"
    namespace = var.jenkins_namespace
  }

  data = {
    "jenkins.yaml" = yamlencode({
      jenkins = {
        systemMessage = "Jenkins configured automatically by Terraform"
        globalNodeProperties = [
          {
            envVars = [
              {
                env = [
                  {
                    key   = "AWS_DEFAULT_REGION"
                    value = var.aws_region
                  },
                  {
                    key   = "AWS_REGION"
                    value = var.aws_region
                  }
                ]
              }
            ]
          }
        ]
      }
    })
  }

  depends_on = [helm_release.jenkins]
}

# Створюємо Secret для роботи з ECR (для Kaniko)
resource "kubernetes_secret" "aws_ecr_secret" {
  metadata {
    name      = "aws-ecr-secret"
    namespace = var.jenkins_namespace
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${local.ecr_registry_url}" = {
          auth = base64encode("AWS:${data.aws_ecr_authorization_token.token.password}")
        }
      }
    })
  }

  depends_on = [kubernetes_namespace.jenkins]
}

# Отримуємо ECR authorization token
data "aws_ecr_authorization_token" "token" {
  registry_id = data.aws_caller_identity.current.account_id
}
