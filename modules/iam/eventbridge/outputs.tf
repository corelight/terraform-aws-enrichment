output "cross_region_role_arn" {
  value = aws_iam_role.cross_region.arn
}

output "cross_region_policy_arn" {
  value = aws_iam_policy.event_bus_put_events_on_central_bus.arn
}