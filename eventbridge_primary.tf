locals {
  plural            = "minutes"
  singular          = "minute"
  unit              = var.scheduled_sync_rule_frequency == 1 ? local.singular : local.plural
  event_source      = ["aws.ec2"]
  event_detail_type = ["EC2 Instance State-change Notification"]
  event_states      = ["stopped", "running", "terminated"]
}

resource "aws_cloudwatch_event_bus" "primary_bus" {
  name = var.primary_event_bus_name
}

resource "aws_cloudwatch_event_rule" "ec2_state_change_primary_rule" {
  name           = var.ec2_state_change_rule_name
  event_bus_name = aws_cloudwatch_event_bus.primary_bus.name
  event_pattern = jsonencode({
    "source" : local.event_source,
    "detail-type" : local.event_detail_type,
    "detail" : {
      "state" : local.event_states
    }
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "ec2_state_change_rule_lambda_target" {
  arn            = aws_lambda_function.enrichment_lambda.arn
  rule           = aws_cloudwatch_event_rule.ec2_state_change_primary_rule.name
  event_bus_name = aws_cloudwatch_event_bus.primary_bus.name
}

resource "aws_lambda_permission" "ec2_state_change_event_bridge_trigger_permission" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_state_change_primary_rule.arn
}

// Primary Region Default Bus --> Corelight Bus
resource "aws_cloudwatch_event_rule" "default_bus_ec2_state_change_rule_arn" {
  name = "${var.ec2_state_change_rule_name}-primary"

  event_pattern = jsonencode({
    "source" : local.event_source,
    "detail-type" : local.event_detail_type,
    "detail" : {
      "state" : local.event_states
    }
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "primary_bus_target_primary" {
  rule     = aws_cloudwatch_event_rule.default_bus_ec2_state_change_rule_arn.name
  arn      = aws_cloudwatch_event_bus.primary_bus.arn
  role_arn = aws_iam_role.cross_region.arn
}
