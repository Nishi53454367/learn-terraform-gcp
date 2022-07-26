/** 変数定義ファイル */

// ここはterraform.tfvarsから参照
variable "project" {}
variable "credentials_file" {}

variable "region" {
  default = "us-central1"
}
variable "zone" {
  default = "us-central1-c"
}
