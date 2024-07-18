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
                "Service": "ec2.amazonaws.com"
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
        "s3:GetObject",
        "s3:ListObjects"
      ],
      "Effect": "Allow",
      "Resource": [
        "{ARN of the S3 bucket used to store enrichment data}",
        "{ARN of the S3 bucket used to store enrichment data}/*"
      ]
    }
  ],
  "Version": "2012-10-17"
}
```