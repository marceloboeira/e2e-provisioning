module "consul" {
  source = "../consul/service"

  id      = "${local.db_name}-primary"
  name    = local.db_name
  node    = var.consul_node
  port    = var.port
  address = module.rds.address

  meta = {
    engine = var.engine
  }
}
