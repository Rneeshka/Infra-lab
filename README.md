# Infra Lab – Terraform + Ansible в Yandex Cloud

Лаба: поднять инфраструктуру с нуля кодом. Terraform создаёт сеть и три виртуалки, Ansible их настраивает. В итоге Nginx-прокси раскидывает запросы на два бэкенда.

## Схема

```
              :3000
  клиент ---> proxy-1 (Nginx, upstream)
                 |
         +-------+-------+
         v               v
    backend-1        backend-2
    (Nginx)          (Nginx)

  всё в одной подсети 10.10.0.0/24, ru-central1-b
```

Каждый бэкенд отвечает `Hello from <hostname>!` – так видно, кто именно ответил.

## Что внутри

`terraform/`
- сеть и подсеть 10.10.0.0/24
- 3 ВМ на Ubuntu (2 vCPU, 2 ГБ): proxy-1, backend-1, backend-2
- SSH-ключ через metadata
- на выходе – IP всех машин

`ansible/`, три роли:
- `common` – hostname и базовые утилиты
- `backend_nginx` – Nginx и страница с именем хоста
- `proxy_nginx` – Nginx на 3000 порту, в `upstream` попадают все хосты из группы `backend` в inventory. Перед применением конфиг проверяется `nginx -t`, перезагрузка только если конфиг поменялся

## Как запустить

```bash
# секреты – в свой файл, он в .gitignore
cp terraform/terraform.tfvars.example terraform/terraform.tfvars

cd terraform
terraform init
terraform apply
terraform output        # IP вписать в ansible/inventory.yaml

cd ../ansible
ansible-playbook -i inventory.yaml playbook.yaml

# проверить балансировку – ответы должны чередоваться
for i in 1 2 3 4; do curl -s http://<proxy_ip>:3000; done
```

После проверки всё сносится `terraform destroy`.

## Структура

```
infra-lab/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
├── ansible/
│   ├── inventory.yaml
│   ├── playbook.yaml
│   └── roles/
│       ├── common/
│       ├── backend_nginx/
│       └── proxy_nginx/
└── screenshots/
```

## Скриншоты

Машины в Yandex Cloud:

![VM list](screenshots/vms.png)

Прогон плейбука:

![Ansible run 1](screenshots/ansible1.png)
![Ansible run 2](screenshots/ansible2.png)

Ответ через прокси. Скрин старый – тогда прокси был прибит к одному backend-1 (второй простаивал, это потом и поправил). Сейчас в upstream оба:

![Nginx proxy 1](screenshots/Nginx-proxy1.png)
![Nginx proxy 2](screenshots/Nginx-proxy2.png)

## Что бы доделал

- inventory генерировать из `terraform output`, а не вписывать IP руками
- убрать у бэкендов публичные IP, ходить к ним только через прокси или bastion
- security groups
- state Terraform хранить в Object Storage
- мониторинг: Prometheus + node_exporter
