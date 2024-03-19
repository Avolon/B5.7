resource "yandex_lb_target_group" "servers_group" {
  name = "servers-group"
  target {
    subnet_id = yandex_vpc_subnet.subnet1.id
#    address   = 
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet2.id
 #   address   = 
  }

}

resource "yandex_lb_network_load_balancer" "load_balancer" {
  name = "load-balancer"
  listener {
    name = "ext-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }

  }
 
 attached_target_group {
    target_group_id = yandex_lb_target_group.servers_group.id
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }

}
