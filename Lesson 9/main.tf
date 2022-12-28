terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.84.0"
    }
  }
}

provider "yandex" {
  # Configuration options
  service_account_key_file = file("../key.json")
  zone = "ru-central1-a"
}

data "yandex_resourcemanager_cloud" "cloudName" {
    cloud_id = "---"
  
}
output "yandex_resourcemanager_cloud-name" {
    value = data.yandex_resourcemanager_cloud.cloudName.name
}
output "yandex_resourcemanager_cloud-id" {
    value = data.yandex_resourcemanager_cloud.cloudName.cloud_id
}
output "yandex_resourcemanager_cloud-timestamp" {
    value = data.yandex_resourcemanager_cloud.cloudName.created_at
}

data "yandex_client_config" "cloudConfig" {
  
}

output "yandex_client_config-cloud_id" {
    value = data.yandex_client_config.cloudConfig.cloud_id
}
output "yandex_client_config-folder_id" {
    value = data.yandex_client_config.cloudConfig.folder_id
}
output "yandex_client_config-zone" {
    value = data.yandex_client_config.cloudConfig.zone
}
output "yandex_client_config-iam_token" {
    value = data.yandex_client_config.cloudConfig.iam_token
    sensitive = true
}