resource "aws_iam_role" "cross_region" {
  name               = var.cross_region_event_bus_role_name
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "event_bus_put_events_on_central_bus" {
  name   = var.cross_region_event_bus_policy_name
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "events:PutEvents"
        ]
        Effect   = "Allow"
        Resource = [var.primary_bus_arn]
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cross_region_role_attach" {
  policy_arn = aws_iam_policy.event_bus_put_events_on_central_bus.arn
  role       = aws_iam_role.cross_region.id
}