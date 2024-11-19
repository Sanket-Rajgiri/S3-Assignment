resource "aws_ecs_cluster" "ecs-cluster" {
  name = local.cluster_config.name
  tags = try(local.cluster_config.tags, {})
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.ecs-cluster.name

  capacity_providers = try(local.cluster_config.capacity_providers, [])

  dynamic "default_capacity_provider_strategy" {
    for_each = try(local.cluster_config.capacity_provider_strategy, [])
    content {
      base              = capacity_provider_strategy.value.base
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
    }

  }
}
