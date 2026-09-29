provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = "b1g86326882jugbbiss5"
  folder_id                = var.folder_id
  zone                     = var.zone
}
