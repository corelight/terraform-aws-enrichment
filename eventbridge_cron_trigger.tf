resource "aws_cloudwatch_event_rule" "scheduled_enrichment_trigger" {
  name                = "every-${var.scheduled_sync_rule_frequency}-${local.unit}"
  description         = "synchronize cloud resources regularly"
  schedule_expression = "rate(${var.scheduled_sync_rule_frequency} ${local.unit})"

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "scheduled_sync_target" {
  arn  = aws_lambda_function.enrichment_lambda.arn
  rule = aws_cloudwatch_event_rule.scheduled_enrichment_trigger.name
}

resource "aws_lambda_permission" "cron_event_bridge_trigger_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.enrichment_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled_enrichment_trigger.arn
}