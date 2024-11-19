# Log Group for Lambda Function Logs
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${local.lambda_config.function_name}"
  retention_in_days = try(local.lambda_config.log_retention_in_days, var.log_retention_in_days)
}

# Assume Role Policy for Lambda
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Lambda Role Creation and Assume Role Policy Attachment
resource "aws_iam_role" "lambda_iam_role" {
  count              = try(local.lambda_config.create_role, var.create_role) ? 1 : 0
  name               = coalesce(var.override_default_role_name_with, "${local.lambda_config.function_name}-execution-role")
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Cloudwatch Log Group Access Policy Document
data "aws_iam_policy_document" "cloudwatch_logs_access" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:${local.region}:${data.aws_caller_identity.current.account_id}:*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${local.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.lambda_config.function_name}:*"]
  }
}

# Log Access Policy 
resource "aws_iam_policy" "cloudwatch_logs_access" {
  count              = try(local.lambda_config.create_role, var.create_role) ? 1 : 0
  name        = "${local.lambda_config.function_name}-CloudwatchLogsAccess"
  path        = "/service-role/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.cloudwatch_logs_access.json
}

# Log Access Policy Attahchment to Lambda Role
resource "aws_iam_role_policy_attachment" "cloudwatch_logs_access" {
  role       = aws_iam_role.lambda_iam_role[0].name
  policy_arn = aws_iam_policy.cloudwatch_logs_access[0].arn
}

# Lambda Function
resource "aws_lambda_function" "s3_listing_lambda" {
  function_name = local.lambda_config.function_name
  role          = try(local.lambda_config.create_role, var.create_role) ? aws_iam_role.lambda_iam_role[0].arn : var.role
  architectures = try(local.lambda_config.architectures, var.architectures)
  memory_size   = try(local.lambda_config.memory_size, var.memory_size)
  ephemeral_storage {
    size = try(local.lambda_config.ephemeral_storage, var.ephemeral_storage)
  }
  package_type = var.package_type
  timeout      = try(local.lambda_config.timeout, var.timeout)
  filename     = data.archive_file.code.output_path
  handler      = try(local.lambda_config.handler, var.handler)
  runtime      = local.lambda_config.runtime
  environment {
    variables = try(local.lambda_config.environment_variables, var.environment_variables)
  }
  tags = try(local.lambda_config.tags, var.tags)
}

data "aws_iam_policy_document" "s3_access" {
    statement {
    sid       = "S3Access"
    actions   = ["s3:ListBucket","S3:GetObject"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${local.lambda_config.environment_variables.BUCKET_NAME}"]
  }
}

resource "aws_iam_policy" "s3_access" {
  count              = try(local.lambda_config.create_role, var.create_role) ? 1 : 0
  name        = "${local.lambda_config.function_name}-S3BucketAccess"
  path        = "/service-role/"
  description = "S3 Bucket Access Policy"
  policy      = data.aws_iam_policy_document.s3_access.json
}

# S3 Access Policy Attahchment to Lambda Role
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.lambda_iam_role[0].name
  policy_arn = aws_iam_policy.s3_access[0].arn
}