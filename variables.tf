variable "corelight_cloud_enrichment_image" {
  description = "The ECR image copy of https://hub.docker.com/r/corelight/sensor-enrichment-aws"
  type        = string
}

variable "corelight_cloud_enrichment_image_tag" {
  description = "The tag of the ECR image"
  type        = string
}

variable "enrichment_bucket_name" {
  description = "The name of the enrichment bucket"
  type        = string
}

### Variables with Defaults
variable "cross_region_event_bus_policy_name" {
  description = "Name of the Corelight Event Bus"
  type        = string
  default     = "corelight-primary-event-bus-policy"
}

variable "cross_region_event_bus_role_name" {
  description = "Name of the IAM Role granting "
  type        = string
  default     = "corelight-cross-region-event-role"
}

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

variable "lambda_name" {
  description = "Name of the Corelight Lambda used to collect and maintain the bucket"
  type        = string
  default     = "corelight-aws-cloud-enrichment"
}

variable "lambda_architecture" {
  description = "Architecture used for the lambda. arm64 is recommended"
  type        = list(string)
  default     = ["arm64"]
}

variable "lambda_env_bucket_prefix" {
  description = "Lambda ENV: The prefix used on all cloud resource metadata object keys. Cannot contain a forward slash."
  type        = string
  default     = "corelight"
}

variable "lambda_env_log_level" {
  description = "Lambda ENV: The log level of the Corelight lambda"
  type        = string
  default     = "info"
}

variable "lambda_timeout" {
  description = "The max duration the Lambda should be allowed to run. This may need to be adjusted for larger implementations"
  type        = number
  default     = 60
}

variable "primary_event_bus_name" {
  description = "The name of the event bus used to notify the Lambda of state changes"
  type        = string
  default     = "corelight-primary-event-bus"
}

variable "cloudwatch_log_group_prefix" {
  description = "The cloudwatch string prepended to the cloud watch log group name"
  type        = string
  default     = "/aws/lambda"
}

variable "cloudwatch_log_group_retention" {
  description = "The Lambda log group retention in days"
  type        = number
  default     = 3
}

variable "scheduled_sync_rule_frequency" {
  description = "The frequency in which the Event Bridge cron should initiate a scheduled workflow in minutes"
  type        = number
  default     = 15
}

variable "ec2_state_change_rule_name" {
  description = "Name of the Event Bridge EC2 state change rule"
  type        = string
  default     = "corelight-ec2-state-change-rule"
}

variable "scheduled_sync_regions" {
  description = "Lambda ENV: The regions the scheduled workflow should scan for running compute instances"
  type        = list(string)
  default = [
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2",
    "ap-south-1",
    "ap-northeast-1",
    "ap-northeast-2",
    "ap-northeast-3",
    "ap-southeast-1",
    "ap-southeast-2",
    "ca-central-1",
    "eu-central-1",
    "eu-west-1",
    "eu-west-2",
    "eu-west-3",
    "eu-north-1",
    "sa-east-1",
  ]
}

variable "tags" {
  description = "Any tags that should be applied to resources deployed by the module"
  type        = object({})
  default     = {}
}