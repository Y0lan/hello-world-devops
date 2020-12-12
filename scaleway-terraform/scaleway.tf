terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
      version = "1.17.2"
    }
  }
}

provider "scaleway" {
  zone = "fr-par-2"
  region = "fr-par"
}

resource "scaleway_instance_ip" "public_ip" {
}

resource "scaleway_instance_security_group" "sg-devops-public" {
  name = "sg-devops-public"
  inbound_default_policy = "accept"
  outbound_default_policy = "accept"
}

data "scaleway_image" "docker" {
  architecture = "x86_64"
  name = "Docker"
}


resource "scaleway_instance_server" "scw-devops-project" {
  name = "terraform-scaleway"
  type = "DEV1-L"
  image = "ubuntu-focal"
  ip_id = scaleway_instance_ip.public_ip.id
  provisioner "file" {
    source = "../docker-compose.yml"
    destination = "/root/docker-compose.yml"
  }
  connection {
    type = "ssh"
    user = "root"
    host = scaleway_instance_ip.public_ip.address
  }
  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt install docker-compose -y",
      "docker-compose up -d",
    ]
  }
}

