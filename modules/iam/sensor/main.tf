resource "aws_iam_role" "corelight_sensor_role" {
  name = var.corelight_sensor_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })


  tags = var.tags
}

resource "aws_iam_policy" "corelight_sensor_policy" {
  name = var.corelight_sensor_policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          var.enrichment_bucket_arn,
          "${var.enrichment_bucket_arn}/*"
        ]
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "corelight_sensor_role_attach" {
  role       = aws_iam_role.corelight_sensor_role.id
  policy_arn = aws_iam_policy.corelight_sensor_policy.arn
}