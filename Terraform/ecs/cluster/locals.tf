locals {
  environment    = terraform.workspace
  region         = lookup(var.regions, local.environment)
  cluster_config = lookup(var.environment, local.environment).cluster_config
}
