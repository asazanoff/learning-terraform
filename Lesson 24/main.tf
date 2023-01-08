terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.84.0"
    }
    sbercloud = {
      source  = "sbercloud-terraform/sbercloud"
      version = "1.10.0"
    }

  }
}
provider "yandex" {
  # Configuration options
  service_account_key_file = file("../key.json")
  zone                     = var.zone //"ru-central1-a"
}
provider "sbercloud" {


}
resource "" "name" {
  
}


resource "yandex_compute_instance" "machine" {
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.lampLatest.id
      size     = 10
    }
  }
  resources {
    cores  = 2
    memory = 2
  }
  network_interface {
    subnet_id = data.yandex_vpc_subnet.subnet1.id
    nat       = true
  }
  platform_id = lookup(var.instance-type, "dev") // X = lookup(map, key)
  count       = 5
  name        = "machine-${count.index + 1}"
  folder_id   = data.yandex_resourcemanager_folder.folderID.id
}










resource "yandex_iam_service_account" "users" {
  count     = length(var.yc-users)
  name      = element(var.yc-users, count.index)
  folder_id = data.yandex_resourcemanager_folder.folderID.id
}
/* Не смог сделать на несколько пользователей множество биндингов. Может потом найду способ
resource "yandex_resourcemanager_folder_iam_binding" "serviceAccountBinding" {
  folder_id = data.yandex_resourcemanager_folder.folderID.id
  for_each  = toset(["editor", "storage.viewer", "ydb.admin"])
  role      = each.value
  members   = ["serviceAccount:${yandex_iam_service_account.users[*].id}"]
  depends_on = [
    yandex_iam_service_account.users
  ]
}
*/
variable "yc-users" {
  description = "List of users for terraform to create"
  default     = ["vasya", "kolya", "petya", "masha", "oksana", "usermaster"]
}


output "creates_iam_users_all" {
  value = yandex_iam_service_account.users[*].name

}

output "created-machines-custom" {

  value = [
    for x in yandex_compute_instance.machine :
    "Machine name: ${x.name}  has external IP ${x.network_interface.0.nat_ip_address}"
  ]


}

output "created-machines-map" {
  value = {
    for x in yandex_compute_instance.machine :
    x.id => x.name
  }

}
output "thirteen-characters-in-ip" {
  value = [
    for x in yandex_compute_instance.machine :
    x.network_interface.0.nat_ip_address
    if length(x.network_interface.0.nat_ip_address) == 13
  ]

}
