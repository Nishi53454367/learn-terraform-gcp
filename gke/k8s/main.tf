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

# k8s
provider "kubernetes" {
  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
}

# namespace
resource "kubernetes_namespace" "test" {
  metadata {
    name = "nginx"
  }
}

# deployment
resource "kubernetes_deployment" "test" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "MyTestApp"
      }
    }
    template {
      metadata {
        labels = {
          app = "MyTestApp"
        }
      }
      spec {
        container {
          image = var.image
          name  = "nginx-container"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# service
resource "kubernetes_service" "test" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.test.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }
  }
}
