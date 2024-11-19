resource "aws_eip" "nat" {
  count = try(local.vpc_conf.nat_eip_count, 0)
  tags  = try(local.vpc_conf.tags, {})
}

module "vpc" {
  source                        = "terraform-aws-modules/vpc/aws"
  version                       = "3.14.0"
  name                          = local.vpc_conf.name
  azs                           = try(local.vpc_conf.azs, [])
  cidr                          = local.vpc_conf.cidr
  private_subnets               = try(local.vpc_conf.private_subnets, [])
  public_subnets                = try(local.vpc_conf.public_subnets, [])
  private_dedicated_network_acl = try(local.vpc_conf.private_dedicated_network_acl, true)
  private_inbound_acl_rules     = try(local.vpc_conf.private_inbound_acl_rules, [])
  private_outbound_acl_rules    = try(local.vpc_conf.private_outbound_acl_rules, [])
  public_dedicated_network_acl  = try(local.vpc_conf.public_dedicated_network_acl, true)
  public_inbound_acl_rules      = try(local.vpc_conf.public_inbound_acl_rules, [])
  public_outbound_acl_rules     = try(local.vpc_conf.public_outbound_acl_rules, [])
  create_database_subnet_group  = try(local.vpc_conf.create_database_subnet_group, false)
  enable_dns_hostnames          = try(local.vpc_conf.enable_dns_hostnames, true)
  enable_nat_gateway            = try(local.vpc_conf.enable_nat_gateway, false)
  single_nat_gateway            = try(local.vpc_conf.single_nat_gateway, true)
  reuse_nat_ips                 = try(local.vpc_conf.reuse_nat_ips, true)
  external_nat_ip_ids           = aws_eip.nat.*.id
  tags                          = try(local.vpc_conf.tags, {})
}
