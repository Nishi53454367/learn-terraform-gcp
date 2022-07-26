# learn-terraform-gcp
Terraform + GCP学習

# チュートリアル
- https://learn.hashicorp.com/tutorials/terraform/google-cloud-platform-build?in=terraform/gcp-get-started
- https://learn.hashicorp.com/tutorials/terraform/google-cloud-platform-change?in=terraform/gcp-get-started
- https://learn.hashicorp.com/tutorials/terraform/google-cloud-platform-destroy?in=terraform/gcp-get-started
- https://learn.hashicorp.com/tutorials/terraform/google-cloud-platform-variables?in=terraform/gcp-get-started
- https://learn.hashicorp.com/tutorials/terraform/google-cloud-platform-outputs?in=terraform/gcp-get-started

## 準備
- [Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)インストール済であること
- GCPプロジェクト作成済であること
  - GCE有効にしておく
  - サービスアカウントキーをJSON形式でダウンロードしておく

## 使い方
### 1. 機密値変数ファイルを以下の内容で作成する
#### ファイル名
`terraform.tfvars`

#### ファイルの中身
```
project          = "GCPプロジェクトID"
credentials_file = "ダウンロードしたサービスアカウントキーファイルのパス"
```

### (必要に応じて)ファイルフォーマット
```
terraform fmt
```

### 2. 初期化
```
terraform init
```

#### 備忘録
`.terraform.lock.hcl`をgit管理から外しているので毎回initして使う前提（これがあればinitは不要になる。）

### (必要に応じて)バリデート
```
terraform validate
```

### 3. 作成
```
terraform apply
```

### (必要に応じて)状態確認
```
terraform show
```

### (必要に応じて)定義した出力変数の内容を表示
```
terraform output
```

### 削除
```
terraform destroy
```

# 応用編
使い方は基本的に同じ

## cloudrun配下
### 準備
- Cloud Run APIを有効にしておく
- 以下のロールを付与したサービスアカウントを作成してダウンロードしたキー(JSON)を指定
  - サービス アカウント ユーザー
  - Cloud Run 管理者ロール

## gke配下
### 準備
- Google Kubernetes Engine APIを有効にしておく
- 以下のロールを付与したサービスアカウントを作成してダウンロードしたキー(JSON)を指定
  - サービス アカウント ユーザー
  - Compute インスタンス管理者（v1）
  - Kubernetes Engine Cluster 管理者

### クラスタ操作
- k8s配下・・・k8sリソース直接デプロイのサンプル
- argocd配下・・・HELM経由でArgoCDをインストールのサンプル