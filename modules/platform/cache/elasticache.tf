module "elasticache" {
  source = "../aws/elasticache"

  region      = var.region
  environment = var.environment
  name        = var.name
}
