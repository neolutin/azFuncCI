# Création d'une ressource de paire de clés SSH
resource "openstack_compute_keypair_v2" "ovhkey" {
  provider   = openstack.ovh
  name       = "ovhcloud"
  public_key = file("~/.ssh/id_rsa.pub")
}
