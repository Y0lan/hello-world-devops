provider "scaleway" {
  organization_id = "46171436-216f-49d2-bfcd-130b98111056"
  zone            = "fr-par-1"
  region          = "fr-par"
}

resource "scaleway_instance_ip" "public_ip" {}

resource "scaleway_instance_volume" "data" {
  size_in_gb = 550
  type = "l_ssd"
}

resource "scaleway_instance_server" "my-ubuntu-instance" {
  type  = "GP1-M"
  image = "ubuntu-focal"

  tags = [ "FocalFossa", "MyUbuntuInstance" ]

  ip_id = scaleway_instance_ip.public_ip.id

  additional_volume_ids = [ scaleway_instance_volume.data.id ]

}
