terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
      version = "1.17.2"
    }
  }
}

provider "scaleway" {
  organization_id = "46171436-216f-49d2-bfcd-130b98111056"
  zone = "fr-par-2"
  region = "fr-par"
}

resource "scaleway_instance_ip" "public_ip" {
}

resource "scaleway_instance_volume" "data" {
  size_in_gb = 30
  type = "l_ssd"
}

resource "scaleway_instance_security_group" "sg-devops-public" {
  name = "sg-devops-public"
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"
}

data "scaleway_image" "docker" {
  architecture = "x86_64"
  name = "Docker"
}


resource "scaleway_instance_server" "scw-devops-project" {
  type = "GP1-X"
  image = "alpine-linux"
  ip_id = scaleway_instance_ip.public_ip.id
  additional_volume_ids = [
    scaleway_instance_volume.data.id]
  provisioner "file" {
    source = "docker-compose.yml"
    destination = "/root/docker-compose.yml"
  }
  connection {
    type = "ssh"
    user = "root"
    host = scaleway_instance_ip.public_ip.address
  }
  provisioner "remote-exec" {
    inline = [
      "docker-compose up -d"
    ]
  }
}
