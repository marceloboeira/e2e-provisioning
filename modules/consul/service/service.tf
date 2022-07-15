resource "consul_service" "service" {
  service_id = var.id
  name       = var.name
  node       = var.node
  port       = var.port
  address    = var.address
  tags       = var.tags
  meta       = var.meta
}
