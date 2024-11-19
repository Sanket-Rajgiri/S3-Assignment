module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "7.0.0"

  name               = local.alb_config.name
  load_balancer_type = try(local.alb_config.load_balancer_type, "application")
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_details.vpc_id
  subnets            = data.terraform_remote_state.vpc.outputs.vpc_details.public_subnets
  security_groups    = [module.security_group.security_group_id]
  idle_timeout       = 600
  http_tcp_listeners = try(local.alb_config.http_tcp_listeners, [])

  https_listener_rules = try(local.alb_config.https_listener_rules, [])

  https_listeners = try(local.alb_config.https_listeners, [])

  target_groups = try(local.alb_config.target_groups, [])

  tags = try(local.alb_config.tags, {})

}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name                     = local.sg_config.name
  description              = try(local.sg_config.description, "Security group for ALB")
  vpc_id                   = data.terraform_remote_state.vpc.outputs.vpc_details.vpc_id
  ingress_cidr_blocks      = try(local.sg_config.ingress_cidr_blocks, [])
  ingress_rules            = try(local.sg_config.ingress_rules, [])
  ingress_with_cidr_blocks = try(local.sg_config.ingress_with_cidr_blocks, [])
  egress_with_cidr_blocks  = try(local.sg_config.egress_with_cidr_blocks, [])
  tags                     = try(local.sg_config.tags, {})
}
