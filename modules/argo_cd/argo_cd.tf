# Створюємо namespace для Argo CD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argo_namespace
  }
}

# Встановлюємо Argo CD через Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = var.argo_repository
  chart      = "argo-cd"
  version    = var.argo_chart_version
  namespace  = var.argo_namespace

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "server.resources.requests.cpu"
    value = var.argo_cpu_request
  }

  set {
    name  = "server.resources.requests.memory"
    value = var.argo_memory_request
  }

  set {
    name  = "server.resources.limits.cpu"
    value = var.argo_cpu_limit
  }

  set {
    name  = "server.resources.limits.memory"
    value = var.argo_memory_limit
  }

  depends_on = [kubernetes_namespace.argocd]
}

# Створюємо namespace для додатку
resource "kubernetes_namespace" "app" {
  metadata {
    name = var.app_namespace
  }
}

# Створюємо Argo CD Application
resource "kubernetes_manifest" "argocd_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = var.app_name
      namespace = var.argo_namespace
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.git_repo_url
        targetRevision = var.git_repo_target_revision
        path           = var.git_repo_path
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = var.app_namespace
      }
      syncPolicy = {
        automated = {
          prune      = true
          selfHeal   = true
          allowEmpty = false
        }
        syncOptions = [
          "CreateNamespace=true",
          "PrunePropagationPolicy=foreground",
          "PruneLast=true"
        ]
      }
    }
  }

  depends_on = [helm_release.argocd, kubernetes_namespace.app]
}

# Створюємо Secret для роботи з ECR
resource "kubernetes_secret" "aws_ecr_secret" {
  metadata {
    name      = "aws-ecr-secret"
    namespace = var.app_namespace
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.ecr_repository_url}" = {
          auth = base64encode("AWS:${data.aws_ecr_authorization_token.token.password}")
        }
      }
    })
  }

  depends_on = [kubernetes_namespace.app]
}

# Отримуємо ECR authorization token
data "aws_ecr_authorization_token" "token" {
  registry_id = data.aws_caller_identity.current.account_id
}

# Data source для отримання поточної AWS account ID
data "aws_caller_identity" "current" {} 