variable "cross_region_role_arn" {
  type        = string
  description = "the IAM role which allows for events to be put on the primary bus from any region"
}

variable "lambda_iam_role_arn" {
  type        = string
  description = "the IAM role which grants the lambda permission to enumerate cloud resources"
}


variable "corelight_cloud_enrichment_image" {
  type = string
}

variable "corelight_cloud_enrichment_image_tag" {
  type = string
}


variable "enrichment_bucket_name" {
  type = string
}

variable "enrichment_bucket_region" {
  type = string
}

variable "lambda_name" {
  type        = string
  default     = "corelight-aws-cloud-enrichment"
  description = ""
}

variable "lambda_architecture" {
  type        = list(string)
  default     = ["arm64"]
  description = ""
}

variable "lambda_env_bucket_prefix" {
  type        = string
  default     = "corelight"
  description = ""
}

variable "lambda_env_log_level" {
  type        = string
  default     = "info"
  description = ""
}

variable "lambda_timeout" {
  type        = number
  default     = 60
  description = ""
}

variable "primary_event_bus_name" {
  type        = string
  default     = "corelight-primary-event-bus"
  description = ""
}

variable "cloudwatch_log_group_retention" {
  type        = number
  default     = 3
  description = ""
}

variable "scheduled_sync_rule_frequency" {
  type        = number
  default     = 15
  description = ""
}

variable "ec2_state_change_rule_name" {
  type        = string
  default     = "corelight-ec2-state-change-rule"
  description = ""
}

variable "scheduled_sync_regions" {
  type = list(string)
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
  description = ""
}

variable "tags" {
  type        = object({})
  description = "Any tags that should be applied to resources deployed by the module"
  default     = {}
}