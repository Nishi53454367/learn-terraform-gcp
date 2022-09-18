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

# GKE
resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-central1"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

# ノード(プリエンティブル)
resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = var.compute_engine_default_service_account_email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
