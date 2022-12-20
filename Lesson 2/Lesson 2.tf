/*
Simple terraform file. Creates weak Compute Instance, Network and subnet.
In metadata there is cloud-init command. 
It tells VM my public SSH key and creates Apache2 web server with custom homepage  
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

resource "yandex_compute_instance" "machine" {
    name = "test"
    platform_id = "standard-v3"
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
      cores = 2
      memory = 2
    }

    network_interface {
      subnet_id = yandex_vpc_subnet.subnet1.id
      //security_group_ids = ["yandex_vpc_security_group.secgroup.id"]
      nat = true
    }

    metadata = {
    user-data = file("metadata.txt")
    }
}


resource "yandex_vpc_network" "network1" {
    name = "Network1"
}



resource "yandex_vpc_subnet" "subnet1" {
    name = "subnet1"
    zone = "ru-central1-b"
    network_id = yandex_vpc_network.network1.id
    v4_cidr_blocks = ["192.168.5.0/24"]
}


/*
resource "yandex_vpc_security_group" "secgroup" {
    name = "secgroup"
    network_id = yandex_vpc_network.network1.id
    description = "My first security group"
    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port = 0
      to_port = 0
      protocol = "ANY"
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
}
*/

output "external_ip_address_machine" {
  value = yandex_compute_instance.machine.network_interface.0.nat_ip_address
}