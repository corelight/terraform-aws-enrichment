variable "lambda_cloudwatch_log_group_arn" {
  description = "ARN of the log group the Lambda will use to create streams and write logs"
  type        = string
}

variable "enrichment_bucket_arn" {
  description = "ARN of the s3 bucket cloud enrichment will use to store cloud resource data"
  type        = string
}

variable "enrichment_ecr_repository_arn" {
  description = "ARN of the ECR repository used to store the AWS enrichment docker image"
  type        = string
}


# Variables with defaults
variable "lambda_iam_role_name" {
  description = "Name of the IAM role used to grant the cloud enrichment lambda permission to enumerate cloud resources and write results to the bucket"
  type        = string
  default     = "corelight-cloud-enrichment-lambda-role"
}

variable "lambda_iam_policy_name" {
  description = "Name of the Lambda IAM policy"
  type        = string
  default     = "corelight-cloud-enrichment-lambda-policy"
}

variable "tags" {
  description = "(optional) Any tags that should be applied to resources deployed by the module"
  type        = object({})
  default     = {}
}
