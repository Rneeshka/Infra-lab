output "proxy_ip" {
  value = yandex_compute_instance.proxy.network_interface[0].nat_ip_address
}

output "backend1_ip" {
  value = yandex_compute_instance.backend1.network_interface[0].nat_ip_address
}

output "backend2_ip" {
  value = yandex_compute_instance.backend2.network_interface[0].nat_ip_address
}
