variable "lambda_iam_role_name" {
  type        = string
  default     = "corelight-cloud-enrichment-lambda-role"
  description = "the name of the IAM role used to grant the cloud enrichment lambda permission to enumerate cloud resources and write results to the bucket"
}

variable "lambda_iam_policy_name" {
  type        = string
  default     = "corelight-cloud-enrichment-lambda-policy"
  description = ""
}

variable "cloudwatch_log_group_arn" {
  type        = string
  description = ""
}

variable "enrichment_bucket_arn" {
  type        = string
  description = ""
}

variable "ecr_repository_arn" {
  type        = string
  description = ""
}

variable "primary_bus_arn" {
  type        = string
  description = ""
}

variable "cross_region_event_bus_policy_name" {
  type        = string
  default     = "corelight-primary-event-bus-policy"
  description = ""
}

variable "cross_region_event_bus_role_name" {
  type        = string
  default     = "corelight-cross-region-event-role"
  description = ""
}

variable "corelight_sensor_role_name" {
  type        = string
  default     = "corelight-sensor-cloud-enrichment-role"
  description = ""
}

variable "corelight_sensor_policy_name" {
  type        = string
  default     = "corelight-sensor-cloud-enrichment-policy"
  description = ""
}

variable "tags" {
  type        = object({})
  description = "Any tags that should be applied to resources deployed by the module"
  default = {}
}