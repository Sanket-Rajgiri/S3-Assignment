regions = {
  prod = "us-east-1"
}
environment = {
  prod = {
    cluster_config = {
      name               = "s3-Listing-Cluster"
      capacity_providers = ["FARGATE", "FARGATE_SPOT"]
      default_capacity_provider_strategy = [
        {
          base              = 0
          capacity_provider = "FARGATE_SPOT"
          weight            = 1
        }
      ]
    }
  }
}
