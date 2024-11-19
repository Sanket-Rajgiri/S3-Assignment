#HTTP API Gateway
resource "aws_apigatewayv2_api" "api" {
  name          = local.api_gateway_config.api_gateway_name
  protocol_type = "HTTP"
  cors_configuration {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["GET"]
    allow_origins = ["*"]
  }
}

#Integration with Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.s3_listing_lambda.invoke_arn
  payload_format_version = "2.0"
}


# API Route
resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "${local.api_gateway_config.method} ${local.api_gateway_config.path}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Permission to Invoke Lambda Function
resource "aws_lambda_permission" "allow_api_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_listing_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*${local.api_gateway_config.path}"
}

#Deployment
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = try(local.api_gateway_config.deployment_name, local.environment)
  auto_deploy = true
}

