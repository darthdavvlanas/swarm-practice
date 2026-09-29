# --- Workers ---
output "worker_names" {
  description = "Имена worker-ВМ"
  value       = yandex_compute_instance.worker[*].name
}

output "worker_ips" {
  description = "Внешние IP worker-ВМ"
  value       = yandex_compute_instance.worker[*].network_interface[0].nat_ip_address
}

# --- Manager ---
output "manager_name" {
  description = "Имя manager-ВМ"
  value       = yandex_compute_instance.manager[0].name
}

output "manager_ip" {
  description = "Внешний IP manager-ВМ"
  value       = yandex_compute_instance.manager[0].network_interface[0].nat_ip_address
}

# --- Карты для inventory ---
output "workers_map" {
  description = "Карта: имя worker → IP"
  value = {
    for inst in yandex_compute_instance.worker :
    inst.name => inst.network_interface[0].nat_ip_address
  }
}

output "managers_map" {
  description = "Карта: имя manager → IP"
  value = {
    for inst in yandex_compute_instance.manager :
    inst.name => inst.network_interface[0].nat_ip_address
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    workers  = yandex_compute_instance.worker[*].name != [] ? {
      for inst in yandex_compute_instance.worker :
      inst.name => inst.network_interface[0].nat_ip_address
    } : {}
    managers = {
      for inst in yandex_compute_instance.manager :
      inst.name => inst.network_interface[0].nat_ip_address
    }
  })
  filename = "${path.module}/inventory.ini"
}