terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

variable "cloudID" {
  type = string
}
variable "folderID" {
  type = string
}
variable "zone" {
  type = string
}
provider "yandex" {
  cloud_id                 = var.cloudID
  folder_id                = var.folderID
  service_account_key_file = file("../key.json")
  zone                     = var.zone
}



resource "yandex_compute_instance" "machine2" {
  name                      = "test2"
  platform_id               = "standard-v2"
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image_id = "fd8kb72eo1r5fs97a1ki"
    }
  }
  scheduling_policy {
    preemptible = true
  }
  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }
  network_interface {
    nat = true
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat_ip_address = yandex_vpc_address.myIP.external_ipv4_address[0].address
  }
  metadata = {
    user-data = templatefile("metadata.txt.tpl", {
      ownerName = "Annabelle"
    })
  }
  lifecycle {
    create_before_destroy = true
  }

  allow_recreate = true
  depends_on = [
    yandex_vpc_address.myIP
  ]
}


resource "yandex_vpc_address" "myIP" {
  name = "my-ip-address"
  external_ipv4_address {
    zone_id = var.zone
  }
  
}
/*
resource "yandex_vpc_security_group" "secGroup" {
  name        = "My security group"
  description = "trying to make dynamic security group with terraform"
  network_id  = yandex_vpc_network.network1.id

  //single port
  ingress {
    from_port      = 22
    to_port        = 22
    protocol       = "TCP"
    v4_cidr_blocks = ["192.168.5.0/24"]
    description    = "Web service"
  }

  //multiple ports
  dynamic "ingress" {
    for_each = ["80", "443", "8080", "1541", "9092"]
    content {
      from_port      = ingress.value
      to_port        = ingress.value
      protocol       = "TCP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      description    = "Port ${ingress.value} service"
    }
  }
  lifecycle {
    ignore_changes = [
      ingress
    ]
  }

}
*/
resource "yandex_vpc_network" "network1" {
  name = "Network1"
}

resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  network_id     = yandex_vpc_network.network1.id
  v4_cidr_blocks = ["192.168.5.0/24"]
}

