resource "yandex_compute_instance" "worker" {
    count                       = 3

    name                        = format("worker-%02d", count.index + 1)
    hostname                    = format("worker-%02d", count.index + 1)
    description                 = format("worker-%02d", count.index + 1)
    folder_id                   = var.folder_id
    zone                        = var.zone
    platform_id                 = "standard-v2"

    allow_stopping_for_update   = true

    resources {
        cores                   = 2
        core_fraction           = 20
        memory                  = 4
    }

    boot_disk {
        initialize_params {
            image_id            = data.yandex_compute_image.fedora43.id
            size                = 20
            type                = "network-hdd"
        }
    }

    network_interface {
        subnet_id               = var.subnet
        nat                     = true
    }

    scheduling_policy {
      preemptible = true
    }

    metadata = {
      user-data = templatefile("${path.module}/linux.tpl", {
        env        = "perf"
        username   = "davlanas"
        ssh_public = file("~/.ssh/k.guskov.pub")
    })
  }
}

resource "yandex_compute_instance" "manager" {
    count                       = 3

    name                        = format("manager-%02d", count.index + 1)
    hostname                    = format("wmanager-%02d", count.index + 1)
    description                 = format("manager-%02d", count.index + 1)
    folder_id                   = var.folder_id
    zone                        = var.zone
    platform_id                 = "standard-v2"

    allow_stopping_for_update   = true

    resources {
        cores                   = 2
        core_fraction           = 20
        memory                  = 4
    }

    boot_disk {
        initialize_params {
            image_id            = data.yandex_compute_image.fedora43.id
            size                = 20
            type                = "network-hdd"
        }
    }

    network_interface {
        subnet_id               = var.subnet
        nat                     = true
    }

    scheduling_policy {
      preemptible = true
    }

    metadata = {
      user-data = templatefile("${path.module}/linux.tpl", {
        env        = "perf"
        username   = "davlanas"
        ssh_public = file("~/.ssh/k.guskov.pub")
    })
  }
}