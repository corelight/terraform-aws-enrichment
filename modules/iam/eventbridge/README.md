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
                "Service": "events.amazonaws.com"
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
              "events:PutEvents"
            ],
            "Effect": "Allow",
            "Resource": "{ARN primary eventbridge bus deployed in the main module}:*"
        }
    ],
    "Version": "2012-10-17"
}
```