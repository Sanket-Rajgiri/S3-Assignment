regions = {
  prod = "us-east-1"
}
environment = {
  prod = {
    vpc_conf = {
      name                          = "S3ListingVPC"
      cidr                          = "10.40.0.0/20"
      private_subnets               = ["10.40.1.0/24", "10.40.2.0/24", "10.40.3.0/24"]
      public_subnets                = ["10.40.4.0/24", "10.40.5.0/24", "10.40.6.0/24"]
      azs                           = ["us-east-1a", "us-east-1b", "us-east-1c"]
      private_dedicated_network_acl = true
      private_inbound_acl_rules     = [{ "cidr_block" : "0.0.0.0/0", "from_port" : 0, "protocol" : "-1", "rule_action" : "allow", "rule_number" : 100, "to_port" : 0 }]
      private_outbound_acl_rules    = [{ "cidr_block" : "0.0.0.0/0", "from_port" : 0, "protocol" : "-1", "rule_action" : "allow", "rule_number" : 100, "to_port" : 0 }]
      public_dedicated_network_acl  = true
      public_inbound_acl_rules      = [{ "cidr_block" : "0.0.0.0/0", "from_port" : 0, "protocol" : "-1", "rule_action" : "allow", "rule_number" : 100, "to_port" : 0 }]
      public_outbound_acl_rules     = [{ "cidr_block" : "0.0.0.0/0", "from_port" : 0, "protocol" : "-1", "rule_action" : "allow", "rule_number" : 100, "to_port" : 0 }]
      enable_dns_hostnames          = true
      enable_nat_gateway            = true
      single_nat_gateway            = true
      nat_eip_count                 = 1

    }
  }
}
