resource "null_resource" "database" {
  triggers = {
    engine  = var.engine
    address = local.address
    port    = var.port
  }
}
