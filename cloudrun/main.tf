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

# CloudRun
resource "google_cloud_run_service" "default" {
  name     = "samplerun"
  location = "us-central1"

  metadata {
    annotations = {
      "run.googleapis.com/client-name" = "terraform"
    }
  }

  template {
    spec {
      containers {
        image = var.image
        ports {
          // 80番ポートでListen
          container_port = 80
        }
      }
    }
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
