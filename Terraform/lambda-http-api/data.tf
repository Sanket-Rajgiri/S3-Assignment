data "aws_caller_identity" "current" {}

data "archive_file" "code" {
  type        = "zip"
  source_file = local.lambda_config.filename
  output_path = "code.zip"
}