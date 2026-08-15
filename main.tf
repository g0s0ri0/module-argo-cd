# Proveedor de Kubernetes (versión moderna ~> 2.0)
provider "kubernetes" {
  cluster_ca_certificate = base64decode(var.kubernetes_cluster_cert_data)
  host                   = var.kubernetes_cluster_endpoint
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws-iam-authenticator"
    args        = ["token", "-i", var.kubernetes_cluster_name]
  }
}

# Proveedor de Helm (configuración dentro de bloque kubernetes)
provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(var.kubernetes_cluster_cert_data)
    host                   = var.kubernetes_cluster_endpoint
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws-iam-authenticator"
      args        = ["token", "-i", var.kubernetes_cluster_name]
    }
  }
}

# Crear el namespace "argocd"
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# Instalar Argo CD usando Helm
resource "helm_release" "argocd" {
  name       = "msur"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argocd"
}
