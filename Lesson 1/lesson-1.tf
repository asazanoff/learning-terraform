/*
First acquaintance with terraform
Tryed to make multiple instances with count
Please input your public SSH key on line 8 of metadata.txt file
*/
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-b"
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1-${count.index}"
  allow_stopping_for_update = true
  platform_id = "standard-v3"
  count = 3

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8kb72eo1r5fs97a1ki"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("metadata.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }

}

resource "yandex_compute_instance" "vm-2" {
  name = "terraform2"
  allow_stopping_for_update = true
  platform_id = "standard-v2"


  resources {
    cores  = 4
    memory = 4
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd8k86p1qgllbcrlddk5"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("metadata.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }

}



resource "yandex_compute_instance" "vm-3" {
  name = "terraform3"
  allow_stopping_for_update = true
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8i5octv9d0lutfs90l"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("metadata.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }

}




resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

/*
output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}

output "internal_ip_address_vm_3" {
  value = yandex_compute_instance.vm-3.network_interface.0.ip_address
}


output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_3" {
  value = yandex_compute_instance.vm-3.network_interface.0.nat_ip_address
}
*/
