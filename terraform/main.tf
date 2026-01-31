terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

# ---------- NETWORK ----------
resource "yandex_vpc_network" "net" {
  name = "lab-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "lab-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.10.0.0/24"]
}


# ---------- VM 1: PROXY ----------
resource "yandex_compute_instance" "proxy" {
  name = "proxy-1"

  resources {
    cores  = 2
    memory = 2
  }

boot_disk {
  initialize_params {
    image_id = "fd883rif8e2s2nqkskao"
    size     = 20
    type     = "network-hdd"
  }
}
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.vm_user}:${file("~/.ssh/id_ed25519.pub")}"
  }
}

# ---------- VM 2: BACKEND ----------
resource "yandex_compute_instance" "backend1" {
  name = "backend-1"

  resources {
    cores  = 2
    memory = 2
  }

boot_disk {
  initialize_params {
    image_id = "fd883rif8e2s2nqkskao"
    size     = 20
    type     = "network-hdd"
  }
}
  
   network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.vm_user}:${file("~/.ssh/id_ed25519.pub")}"
  }
}

# ---------- VM 3: BACKEND ----------
resource "yandex_compute_instance" "backend2" {
  name = "backend-2"

  resources {
    cores  = 2
    memory = 2
  }

boot_disk {
  initialize_params {
    image_id = "fd883rif8e2s2nqkskao"
    size     = 20
    type     = "network-hdd"
  }
}


  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.vm_user}:${file("~/.ssh/id_ed25519.pub")}"
  }
}
