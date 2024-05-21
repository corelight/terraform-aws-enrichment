resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${aws_lambda_function.enrichment_lambda.function_name}"
  retention_in_days = var.cloudwatch_log_group_retention

  tags = var.tags
}

resource "aws_lambda_function" "enrichment_lambda" {
  function_name = var.lambda_name
  role          = aws_iam_role.lambda_role.arn
  image_uri     = "${var.corelight_cloud_enrichment_image}:${var.corelight_cloud_enrichment_image_tag}"
  package_type  = "Image"
  timeout       = var.lambda_timeout
  architectures = var.lambda_architecture
  environment {
    variables = {
      BUCKET_NAME   = var.enrichment_bucket_name
      BUCKET_REGION = var.enrichment_bucket_region
      PREFIX        = var.lambda_env_bucket_prefix
      REGIONS       = join(",", var.scheduled_sync_regions)
      LOG_LEVEL     = var.lambda_env_log_level
    }
  }

  tags = var.tags
}

