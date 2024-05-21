output "sensor_role_arn" {
  value = aws_iam_role.corelight_sensor_role.arn
}

output "sensor_policy_arn" {
  value = aws_iam_policy.corelight_sensor_policy.arn
}