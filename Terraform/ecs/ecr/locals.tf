locals {
  environment = terraform.workspace
  region      = lookup(var.regions, local.environment)
  ecr_config  = lookup(var.environment, local.environment).ecr_config
}
