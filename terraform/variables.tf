variable "cloud_id" {}
variable "folder_id" {}
variable "zone" {
  default = "ru-central1-b"
}

variable "vm_user" {
  default = "ubuntu"
}

variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
}
