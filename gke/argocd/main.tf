terraform {
  // 使用するプロバイダー情報を定義
  required_providers {
    google = {
      // sourceは使用したいプロバイダーを指定
      // デフォルトはTerraformレジストリ(https://registry.terraform.io/)からインストールされる
      source = "hashicorp/google"
      // バージョンは指定しないと最新バージョンを取得
      version = "4.31.0"
    }
  }
}

# GCPプロジェクトとサービスアカウント設定
provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
}

# クラスタ情報
# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}
data "google_container_cluster" "my_cluster" {
  name     = "my-gke-cluster"
  location = "us-central1"
}

# helm
provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
    )
  }
}

# argocd
resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.0.0"
  create_namespace = true
  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}
