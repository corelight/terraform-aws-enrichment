# IAM Role
An AWS IAM role needs to be created with the following assume role policy and permissions

# Assume Role Policy
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}

```

# Permissions

```json
{
  "Statement": [
    {
      "Action": [
        "logs:PutLogEvents",
        "logs:CreateLogStream"
      ],
      "Effect": "Allow",
      "Resource": "{ARN of the log group the enrichment Lambda will use to create streams and write logs}:*"
    },
    {
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeVpcs",
        "ec2:DescribeVpcEndpoints"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListObjects",
        "s3:DeleteObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "{ARN of the S3 bucket used to store enrichment data}",
        "{ARN of the S3 bucket used to store enrichment data}/*"
      ]
    },
    {
      "Action": [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ],
      "Effect": "Allow",
      "Resource": "{ARN of the ECR repository used to store the enrichment dockerhub image}"
    }
  ],
  "Version": "2012-10-17"
}
```