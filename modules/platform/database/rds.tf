module "rds" {
  source = "../aws/rds"

  region      = var.region
  environment = var.environment
  name        = var.name
}
