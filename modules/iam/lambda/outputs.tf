output "lambda_iam_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "lambda_policy_arn" {
  value = aws_iam_policy.lambda_access_policy.arn
}