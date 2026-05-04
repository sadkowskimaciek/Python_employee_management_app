terraform {
  # DODANE: Bezpieczne przechowywanie stanu lokalnie, poza katalogiem roboczym Jenkinsa
  backend "local" {
    path = "/var/jenkins_home/terraform_state/moj_projekt/terraform.tfstate" 
  }

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.2"
    }
  }
}

provider "docker" {}

resource "docker_network" "siec_projektowa" {
  name = "moja-siec-projektowa"
}

resource "docker_image" "moja_aplikacja_obraz" {
  name         = "moja-aplikacja:${var.image_tag}"
  keep_locally = true
}

resource "docker_container" "moja_aplikacja_kontener" {
  name  = var.container_name
  image = docker_image.moja_aplikacja_obraz.image_id

  ports {
    internal = 8080
    external = 80
  }

  networks_advanced {
    name = docker_network.siec_projektowa.name
  }
}

