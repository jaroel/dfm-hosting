terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3"
    }
  }
}

provider "docker" {
  host = "ssh://root@debian@orb"
}

# resource "docker_network" "proxy" {
#   name = "proxy"
# }

# #
# # Traefik
# #
# resource "docker_image" "traefik" {
#   name = "traefik:v3"
# }
# resource "docker_container" "traefik" {
#   name    = "traefik"
#   image   = docker_image.traefik.image_id
#   restart = "unless-stopped"

#   ports {
#     internal = 80
#     external = 80
#   }

#   ports {
#     internal = 443
#     external = 443
#   }

#   networks_advanced {
#     name = docker_network.proxy.id
#   }
#   volumes {
#     host_path      = "/var/run/docker.sock"
#     container_path = "/tmp/docker.sock"
#     read_only      = true
#   }
# }

#
# Dinxper FM Uitzending gemist
#
resource "docker_image" "dfmuzg" {
  # dfmuzg:latest
  name         = "dfmuzg:latest"
  keep_locally = true
}
resource "docker_container" "dfmuzg" {
  name    = "dfmuzg"
  image   = docker_image.dfmuzg.image_id
  restart = "unless-stopped"

  ports {
    internal = 80
    external = 8000
  }

  # networks_advanced {
  #   name = docker_network.proxy.id
  # }
}
