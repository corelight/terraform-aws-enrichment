resource "aws_iam_role" "lambda_role" {
  name = var.lambda_iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "lambda_access_policy" {
  name = var.lambda_iam_policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeVpcs",
          "ec2:DescribeVpcEndpoints",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "${var.lambda_cloudwatch_log_group_arn}:*"
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListObjects",
          "s3:DeleteObject"
        ]
        Effect = "Allow"
        Resource = [
          var.enrichment_bucket_arn,
          "${var.enrichment_bucket_arn}/*"
        ]
      },
      {
        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Effect   = "Allow"
        Resource = var.enrichment_ecr_repository_arn
      }

    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  policy_arn = aws_iam_policy.lambda_access_policy.arn
  role       = aws_iam_role.lambda_role.id
}
