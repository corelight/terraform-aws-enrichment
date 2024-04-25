output "cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.log_group.arn
}

output "lambda_arn" {
  value = aws_lambda_function.enrichment_lambda.arn
}

output "primary_event_bus_arn" {
  value = aws_cloudwatch_event_bus.primary_bus.arn
}

output "primary_ec2_state_change_rule_arn" {
  value = aws_cloudwatch_event_rule.ec2_state_change_primary_rule.arn
}

output "default_bus_ec2_state_change_rule_arn" {
  value = aws_cloudwatch_event_rule.default_bus_ec2_state_change_rule_arn.arn
}

output "scheduled_sync_rule_arn" {
  value = aws_cloudwatch_event_rule.scheduled_enrichment_trigger.arn
}
