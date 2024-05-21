output "event_bridge_rule_arn" {
  value = aws_cloudwatch_event_rule.ec2_state_change_secondary_region_rule.arn
}