locals {
  environment = terraform.workspace
  region      = lookup(var.regions, local.environment)
  service_conf = lookup(var.environment, local.environment).service_conf
}
