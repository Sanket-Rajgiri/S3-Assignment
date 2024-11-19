regions = {
  prod = "us-east-1"
}
environment = {
  prod = {
    service_conf = {
      name             = "s3-listing-service"
      container_name   = "s3-listing-service"
      desired_count    = 1
      container_port   = 5000
      cloud_service_cd = "container_definition.json"
      assign_public_ip = false
      capacity_provider_strategy = [
        {
          base              = 0
          capacity_provider = "FARGATE_SPOT"
          weight            = 1
        }
      ]
    }


  }
}
