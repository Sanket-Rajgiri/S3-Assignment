locals {
  environment = terraform.workspace
  region      = lookup(var.regions, local.environment)
  vpc_conf    = lookup(var.environment, local.environment).vpc_conf
}
