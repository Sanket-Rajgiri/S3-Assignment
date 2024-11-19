locals {
  environment = terraform.workspace
  region = lookup(var.regions,local.environment)
  lambda_config = lookup(var.configuration,local.environment).lambda_config
  api_gateway_config = lookup(var.configuration,local.environment).api_gateway_config
}