terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.62.0"
    }
  }
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "tf-test-state"
    region     = "ru-central1-a"
    key        = "web.tfstate"
    access_key = "YCAJE_5t29MA0LJmxi-bK-k-W"
    secret_key = "YCPbdSGmuzWAPMm3Tx0y4WSRw2LZAAl3aW6623_w"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
provider "yandex" {
  service_account_key_file = file("~/aut.json")
  cloud_id                 = "skill"
  folder_id                = "b1gcapfb425k1p909eqv"
  zone                     = "ru-central1-a"
}

resource "yandex_vpc_network" "network" {
  name = "network"
}

resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet2" {
  name           = "subnet2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}


module "ya_instance_1" {
  source                = "./modules/instance"
  family_image = "lemp"
  vpc_subnet_id         = yandex_vpc_subnet.subnet1.id
  zone                  = yandex_vpc_subnet.subnet1.zone
}

module "ya_instance_2" {
  source                = "./modules/instance"
  family_image = "lamp"
  vpc_subnet_id         = yandex_vpc_subnet.subnet2.id
  zone                  = yandex_vpc_subnet.subnet2.zone
}
