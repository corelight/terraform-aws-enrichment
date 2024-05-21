resource "aws_cloudwatch_event_rule" "ec2_state_change_secondary_region_rule" {
  name = var.secondary_ec2_state_change_rule_name

  event_pattern = jsonencode({
    "source" : ["aws.ec2"],
    "detail-type" : ["EC2 Instance State-change Notification"],
    "detail" : {
      "state" : ["stopped", "running", "terminated"]
    }
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "primary_bus_target" {
  rule     = aws_cloudwatch_event_rule.ec2_state_change_secondary_region_rule.name
  arn      = var.primary_event_bus_arn
  role_arn = var.cross_region_eventbridge_role_arn
}