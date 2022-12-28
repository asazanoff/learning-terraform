output "ipaddress" {
  value = yandex_vpc_address.myIP.external_ipv4_address.0.address
}

output "web_server_instance_ID" {
  value = yandex_compute_instance.machine2.id
}



