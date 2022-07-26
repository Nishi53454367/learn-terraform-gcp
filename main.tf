/** 構成ファイル本体 */

terraform {
  // 使用するプロバイダー情報を定義
  required_providers {
    google = {
      // sourceは使用したいプロバイダーを指定
      // デフォルトはTerraformレジストリ(https://registry.terraform.io/)からインストールされる
      source = "hashicorp/google"
      // バージョンは指定しないと最新バージョンを取得
      version = "4.30.0"
    }
  }
}

// プロバイダー構成情報を定義
provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

// ここからリソースタイプとリファレンス名を指定して作成するリソースを定義

// VPCネットワーク
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

// GCEインスタンス
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}
