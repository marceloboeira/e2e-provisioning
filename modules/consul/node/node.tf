resource "consul_node" "node" {
  name    = var.name
  address = var.address
}
