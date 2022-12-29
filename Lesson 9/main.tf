terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.84.0"
    }
  }
}
provider "yandex" {
  # Configuration options
  service_account_key_file = file("../key.json")
  zone                     = "ru-central1-a"
}

//Working with data sources
//Get Cloud ID
data "yandex_resourcemanager_cloud" "cloudID" {
  name = "cloud-ie"
}
//Get Folder ID
data "yandex_resourcemanager_folder" "folderID" {
  cloud_id = data.yandex_resourcemanager_cloud.cloudID.cloud_id
  name     = "default"
}

data "yandex_compute_image" "ubuntuLatest" {
  //If you specify family without folder_id then lookup takes place in the 'standard-images' folder.
  family = "ubuntu-2204-lts"
}

data "yandex_compute_image" "lampLatest" {
  //If you specify family without folder_id then lookup takes place in the 'standard-images' folder.
  family = "lamp"
}

data "yandex_vpc_network" "default" {
  name      = "default"
  folder_id = data.yandex_resourcemanager_folder.folderID.id
}

data "yandex_iam_service_account" "sa" {
  name      = "service"
  folder_id = data.yandex_resourcemanager_folder.folderID.id
}

resource "yandex_compute_instance_group" "vm" {
  service_account_id = data.yandex_iam_service_account.sa.id
  folder_id          = data.yandex_resourcemanager_folder.folderID.folder_id
  scale_policy {
    auto_scale {
      cpu_utilization_target = 30
      initial_size           = 3
      max_size               = 10
      min_zone_size          = 1
      measurement_duration   = 120

    }
  }
  deploy_policy {
    max_creating     = 4
    max_deleting     = 1
    max_expansion    = 2
    max_unavailable  = 2
    startup_duration = 120
  }
  instance_template {
    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.lampLatest.id
      }
    }
    resources {
      cores  = 2
      memory = 2
      //core_fraction = 20
    }
    //***************************************
    network_interface {
      subnet_ids = [
        data.yandex_vpc_network.default.subnet_ids.0,
        data.yandex_vpc_network.default.subnet_ids.1,
        data.yandex_vpc_network.default.subnet_ids.2
      ]
    }
    scheduling_policy {
      preemptible = true
    }
    description = "My web resource"
    name        = "my-instance-{instance.index}"
  }
  name = "website-group"
  health_check {
    interval            = 6
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    http_options {
      port = 80
      path = "/"
    }
  }
  load_balancer {
    target_group_name        = "target-gp"
    target_group_description = "Description of target group"
    target_group_labels = {
      "service" = "web"
    }
    max_opening_traffic_duration = 60
  }
  description                  = "My highly available web server"
  max_checking_health_duration = 120
  allocation_policy {
    zones = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
  }
}

resource "yandex_lb_network_load_balancer" "lb" {
  description = "my load balancer for highly available website"
  listener {
    name        = "listener"
    port        = 80
    target_port = 80
    protocol    = "tcp"
    external_address_spec {
    }
  }
  attached_target_group {
    target_group_id = yandex_compute_instance_group.vm.load_balancer.0.target_group_id
    healthcheck {
      name = "my-health-check"
      http_options {
        path = "/"
        port = 80
      }
    }

  }
  folder_id = data.yandex_resourcemanager_folder.folderID.folder_id

}



output "cloudID" {
  value = data.yandex_resourcemanager_cloud.cloudID.cloud_id
}

output "folderID" {
  value = data.yandex_resourcemanager_folder.folderID.folder_id
}

output "imageID" {
  value = data.yandex_compute_image.ubuntuLatest.id
}
output "IP" {
  value = yandex_lb_network_load_balancer.lb.listener

}
