//Working with data sources
//Get Cloud ID
data "yandex_resourcemanager_cloud" "cloudID" {
  name = var.cloudName //"cloud-ie"
}
//Get Folder ID
data "yandex_resourcemanager_folder" "folderID" {
  cloud_id = data.yandex_resourcemanager_cloud.cloudID.cloud_id
  name     = "default"
}

data "yandex_compute_image" "ubuntuLatest" {
  //If you specify family without folder_id then lookup takes place in the 'standard-images' folder.
  family = var.ubuntu-version
}

data "yandex_compute_image" "lampLatest" {
  //If you specify family without folder_id then lookup takes place in the 'standard-images' folder.
  family = var.lamp-version
}

data "yandex_vpc_network" "default" {
  name      = "default"
  folder_id = data.yandex_resourcemanager_folder.folderID.id
}

data "yandex_iam_service_account" "sa" {
  name      = "service"
  folder_id = data.yandex_resourcemanager_folder.folderID.id
}