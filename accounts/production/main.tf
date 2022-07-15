provider "consul" {
  address = "127.0.0.1:8500"
}

# A dummy node to register all RDS clusters
module "consul_rds_node" {
  source = "./../../modules/consul/node"

  name    = "rds"
  address = "-"
}

# A dummy node to register all ElastiCache clusters
module "consul_cache_node" {
  source = "./../../modules/consul/node"

  name    = "cache"
  address = "-"
}

# An example end-to-end provisioned database, with:
# * a (fake) RDS instance
# * a consul alias for internal service discovery
module "rds_core" {
  source = "./../../modules/platform/database"

  region      = "us-east-1"
  environment = "production"
  name        = "core"
  consul_node = module.consul_rds_node.name
}

# An example end-to-end provisioned cache, with:
# * a (fake) ElastiCache instance
# * a consul alias for internal service discovery
module "elasticache_core" {
  source = "./../../modules/platform/cache"

  region      = "us-east-1"
  environment = "production"
  name        = "core"
  consul_node = module.consul_cache_node.name
}
