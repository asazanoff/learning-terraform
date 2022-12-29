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
