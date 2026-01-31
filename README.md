# Infra Lab — Terraform + Ansible

## Описание
Лабораторная работа по развёртыванию инфраструктуры в Yandex Cloud:
- 3 VM (proxy + 2 backend) через Terraform
- Настройка через Ansible
- Nginx proxy на порту 3000
- Backend nginx с кастомной страницей

## Структура репозитория
infra-lab/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
└── ansible/
    ├── inventory.yaml
    ├── playbook.yaml
    └── roles/
    ## Скриншоты

### 1. Виртуальные машины в Yandex Cloud
![VM list](screenshots/vms.png)

### 2. Выполнение Ansible playbook
![Ansible run](screenshots/ansible.png)

### 3. Результат в браузере
![Nginx proxy](screenshots/browser.png)
