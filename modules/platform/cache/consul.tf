module "consul" {
  source = "../consul/service"

  id      = "${local.db_name}-primary"
  name    = local.cache_name
  node    = var.consul_node
  port    = var.port
  address = module.elasticache.address

  meta = {
    engine = var.engine
  }
}
