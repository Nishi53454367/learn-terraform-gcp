// ipという名前の出力変数を定義する
// terraform outputコマンドでipが出力することができる
output "ip" {
  description = "作成したインスタンスのIPアドレス"
  value       = google_compute_instance.vm_instance.network_interface.0.network_ip
}
