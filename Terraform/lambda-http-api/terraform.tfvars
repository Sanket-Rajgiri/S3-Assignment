regions = {
  prod = "us-east-1"
}

configuration = {
  prod = {
    lambda_config = {
      function_name     = "s3BucketListing"
      create_role       = true
      architectures     = ["x86_64"]
      memory_size       = 128
      ephemeral_storage = 512
      timeout           = 3
      filename          = "../../Lambda Function/lambda_function.py"
      handler           = "lambda_function.lambda_handler"
      runtime           = "python3.10"
      environment_variables = {
        BUCKET_NAME = "s3-listing-bucket"
      }
    }
    api_gateway_config = {
      api_gateway_name = "s3BucketListing"
      method           = "GET"
      path             = "/list-bucket-content/{path+}"
      deployment_name  = "$default"
    }

  }
}
