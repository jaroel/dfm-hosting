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

resource "docker_network" "proxy" {
  name = "proxy"
}

#
# Traefik
#
resource "docker_image" "traefik" {
  name = "traefik:v3.0"
}
resource "docker_container" "traefik" {
  name    = "traefik"
  image   = docker_image.traefik.image_id
  restart = "unless-stopped"

  ports {
    internal = 80
    external = 80
  }

  ports {
    internal = 8080
    external = 8080
  }

  networks_advanced {
    name = docker_network.proxy.name
  }
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
    read_only      = true
  }
  command = [
    "--api.insecure=true",
    "--providers.docker=true",
    "--providers.docker.exposedbydefault=false",
    "--providers.docker.network=proxy",
    "--entrypoints.web.address=:80",
    # "--entrypoints.web.http.redirections.entrypoint.to=websecure",
    # "--entrypoints.web.http.redirections.entrypoint.scheme=https",
    # "--entrypoints.websecure.address=:443",
    # "--entrypoints.websecure.asDefault=true",
    # "--entrypoints.websecure.http.tls.certresolver=myresolver",
    # "--certificatesresolvers.myresolver.acme.httpchallenge=true",
    # "--certificatesresolvers.myresolver.acme.httpchallenge.entrypoint=web",
    # "--certificatesresolvers.myresolver.acme.email=roel@jaroel.nl",
    # "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json",
    # "--certificatesresolvers.myresolver.acme.caserver=https://acme-staging-v02.api.letsencrypt.org/directory",
  ]
}

#
# Dinxper FM Uitzending gemist
#
resource "docker_image" "dfmuzg" {
  name         = "dfmuzg:latest"
  keep_locally = true
}
resource "docker_container" "dfmuzg" {
  name    = "dfmuzg"
  image   = docker_image.dfmuzg.image_id
  restart = "unless-stopped"
  command = ["python", "-m", "uvicorn", "server:app", "--host=0.0.0.0", "--port=8000"]

  labels {
    label = "traefik.enable"
    value = "true"
  }
  labels {
    label = "traefik.http.routers.dfmuzg.rule"
    value = "Host(`uzg.debian.orb.local`)"
  }
  labels {
    label = "traefik.http.routers.dfmuzg.entrypoints"
    value = "web"
  }
  # labels {
  #   label = "traefik.http.routers.dfmuzg.tls.certresolver"
  #   value = "myresolver"
  # }

  networks_advanced {
    name = docker_network.proxy.name
  }

}
