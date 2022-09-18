/** 変数定義ファイル(terraform.tfvarsから参照) */

/* サービスアカウントキーファイル */
variable "credentials_file" {}

/* GCPプロジェクト名 */
variable "project" {}

/* サービスアカウントメールアドレス */
variable "compute_engine_default_service_account_email" {}
