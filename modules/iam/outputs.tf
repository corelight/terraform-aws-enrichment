output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "eventbridge_role_arn" {
  value = aws_iam_role.cross_region.arn
}

output "sensor_role" {
  value = aws_iam_role.corelight_sensor_role.arn
}