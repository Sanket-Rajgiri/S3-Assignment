locals {
  region      = var.regions[terraform.workspace]
  environment = terraform.workspace
  env_conf    = lookup(var.environment, local.environment)
  alb_config  = lookup(var.environment, local.environment).alb_config
  sg_config   = lookup(var.environment, local.environment).sg_config
}